import 'package:flutter/material.dart';
// import 'package:extended_masked_text/extended_masked_text.dart';
import 'dart:math';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../utils/validators.dart';
import '../../functions/api.dart';
import '../../config/config.dart';
import 'code_page.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  /* var _phoneController = new MaskedTextController(mask: '+7 (###) ###-##-##',
  translator: {'#': new RegExp(r'[0-9]')}); */
  TextEditingController _phoneController = TextEditingController();
  var _maskPhoneFormatter = new MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]'),},
    type: MaskAutoCompletionType.lazy
  );
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneInfoVisible = false;
  bool _isNextButtonActive = true;
  late int _verificationCode;
  late Map _data;
  Config _config = Config();

  void initState(){
    super.initState();
    /* _phoneController.beforeChange = (String previousBefore, String nextBefore) {
        _phoneController.afterChange =(String previousAfter, String nextAfer) {
          if (nextBefore.startsWith('+7', 1))
          {
          _phoneController.text = _phoneController.text.substring(0, _phoneController.text.length - 1);
         } 
        };
      return true;
    }; */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Номер телефона'),
      centerTitle: true,
      iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            child: Text('Введите номер телефона для восстановления пароля')),
          _isPhoneInfoVisible ? 
          SizedBox(
            height: 30,
            child: Text('Данный номер телефона не зарегистрирован',
            style: TextStyle(color: Colors.red),),) :
            SizedBox(height: 30,),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Center(
                child: SizedBox(width: 300,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      inputFormatters: [_maskPhoneFormatter],
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (Validator.checkIsTextIsEmpty(text)){
                          return 'Поле не должно быть пустым';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '+${_config.getCountryCode} (000) 000-00-00',
                        labelText: 'Номер телефона'),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: _isNextButtonActive ? () async {
                      if (_formKey.currentState!.validate()){
                        setState(() {
                        _isNextButtonActive = false;
                        _isPhoneInfoVisible = false;
                      });
                      if (await Api.checkPhoneIsExist(_config.getCountryCode + _maskPhoneFormatter.getUnmaskedText())){
                        _verificationCode = Random().nextInt(9000) + 1000;
                        _data = {
                          'phone' : _config.getCountryCode + _maskPhoneFormatter.getUnmaskedText()
                        };
                        await Api.send4DigitCode(_data['phone'], _verificationCode, false);
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => CodePage(
                          data: _data, verificationCode: _verificationCode, isFromRegPage: false)));
                      } else {
                        setState(() {
                          _isPhoneInfoVisible = true;
                          _isNextButtonActive = true;
                        });
                      }
                      }
                      
                    }
                    : null, 
                    child: _isNextButtonActive ? Text('Далее') : 
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator())
                      ),
                  ]),),))
        ],
      ),
    );
  }
}