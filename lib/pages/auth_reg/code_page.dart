import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../../functions/api.dart';
import 'reg_page.dart';
import '../../app.dart';
import 'change_password_page.dart';
import '../../functions/authorization.dart';
import '../../functions/modify.dart';

class CodePage extends StatefulWidget {
  Map data;
  int verificationCode;
  bool isFromRegPage;
  CodePage({super.key,
  required this.data,
  required this.verificationCode,
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
  bool _isBackButtonPressed = false;

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
    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo,) {
      if (routeInfo.ifRouteChanged(context)) {
        return false;
      } else {
        onPopScope(context,_isBackButtonPressed);
          _isBackButtonPressed = true;
          Future.delayed(Duration(seconds: 4), () {
            _isBackButtonPressed = false;
          });
      return true;
      }
    }, name: 'backButton', context: context);
    _verificationCode = widget.verificationCode;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    BackButtonInterceptor.removeByName('backButton');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подтверждение'),
      centerTitle: true,
      automaticallyImplyLeading: false,),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          
          
        },
        child: SafeArea(
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
                              widget.data['password'],
                              widget.data['privacy_policy']);
                              await Authorization.login();
                              await prefs.setInt('userId', await Api.getUserId(widget.data['phone']));
                              Navigator.push(
                          context, MaterialPageRoute(builder: (context) => App()));
                            } else {
                              Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ChangePasswordPage(phone: widget.data['phone'],)));
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
      ),
    );
  }
}