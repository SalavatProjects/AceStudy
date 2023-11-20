import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/api.dart';
import 'reg_page.dart';
import '../app.dart';
import 'change_password_page.dart';
import '../functions/authorization.dart';

class CodePage extends StatefulWidget {
  Map data;
  int vericationCode;
  bool isFromRegPage;
  CodePage({super.key,
  required this.data,
  required this.vericationCode,
  required this.isFromRegPage});

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  
  int _attempt = 3;
  int _start = 60;
  late Timer _timer;
  late int _verificationCode;
  bool _showAttempt = false;
  bool _sendCodeAgain = false;
  bool _showDownload = false;
  bool _onEditing = true;
  int? _code;

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, 
    (Timer timer) { 
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _sendCodeAgain = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _verificationCode = widget.vericationCode;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подтверждение'),
      centerTitle: true,
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          if (widget.isFromRegPage){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegPage()));
          }
        },),),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _attempt != 0 ?
                  SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        Center(
                          child: Text('Введите код, отправленный Вам по SMS'),
                          ),
                    VerificationCode(
                      keyboardType: TextInputType.number,
                      length: 4,
                      autofocus: true,
                      clearAll: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Очистить'),
                        ),
                      onCompleted: (String value) async {
                        setState(() {
                          _showDownload = true;
                        });
                        _code = int.parse(value);
                        if (_code == _verificationCode) {
                          if (widget.isFromRegPage) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await Api.saveUser(widget.data['name'], 
                            widget.data['surname'], 
                            widget.data['login'], 
                            widget.data['phone'], 
                            widget.data['password']);
                            await Authorization.login();
                            await prefs.setInt('userId', await Api.getUserId(widget.data['login']));
                            Navigator.push(
                        context, MaterialPageRoute(builder: (context) => App()));
                          } else {
                            Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                          }
                        } else {
                          setState(() {
                            _showAttempt = true;
                            _attempt--;
                          });
                        }
                        setState(() {
                          _showDownload = false;
                        });
                        // print(_code);
                      }, 
                      onEditing: (bool value) {
                          _onEditing = value;
                          if(!_onEditing) FocusScope.of(context).unfocus();
                      }),
                      ],
                    ),
                  ) 
                  :
                  SizedBox(height: 120,),  
                _showDownload ?
                SizedBox(height: 36,
                child: CircularProgressIndicator(),)
                : _showAttempt ?
                SizedBox(height: 36,
                child: Text('Код введен неверно! Осталось $_attempt попыток',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),),
                ) : 
                SizedBox(height: 36,),
                _sendCodeAgain ? 
                SizedBox(
                  height: 20,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                    setState(() {
                      _start = 60;
                      _startTimer();
                      _sendCodeAgain = false;
                      _attempt = 3;
                      _showAttempt = false;
                    });
                    _verificationCode = Random().nextInt(9000) + 1000;
                    if (widget.isFromRegPage)
                      {
                        await Api.send4DigitCode(widget.data['phone'], _verificationCode, true);
                      } else {
                        await Api.send4DigitCode(widget.data['phone'], _verificationCode, false);
                      }
                  }, 
                  child: Text('Отправить код повторно')),
                ) 
                :
                SizedBox(
                  height: 20,
                  child: Text('Отправить код через $_start секунд',
                  style: TextStyle(color: Colors.grey),),
                ),
                ],
                ),
            ),
          )
        
         ),
    );
  }
}