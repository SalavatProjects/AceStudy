import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'dart:math';

import '../utils/validators.dart';
import '../functions/api.dart';
import 'code_page.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  var _phoneController = new MaskedTextController(mask: '+# (###) ###-##-##',
  translator: {'#': new RegExp(r'[0-9]')});
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneInfoVisible = false;
  bool _isNextButtonActive = true;
  late int _verificationCode;
  late Map _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Номер телефона'),
      centerTitle: true,),
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
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (Validator.checkIsTextIsEmpty(text)){
                          return 'Поле не должно быть пустым';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '+0 (000) 000-00-00',
                        labelText: 'Номер телефона'),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: _isNextButtonActive ? () async {
                      if (_formKey.currentState!.validate()){
                        setState(() {
                        _isNextButtonActive = false;
                        _isPhoneInfoVisible = false;
                      });
                      if (await Api.checkPhoneIsExist(_phoneController.unmasked)){
                        _verificationCode = Random().nextInt(9000) + 1000;
                        _data = {
                          'phone' : _phoneController.unmasked
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