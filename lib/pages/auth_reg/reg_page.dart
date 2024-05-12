import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/validators.dart' as customValidator;
import '../../config/config.dart';
import '../../functions/api.dart';
import '../../functions/modify.dart';
import 'code_page.dart';
import 'login_page.dart';


class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  _RegPageState createState() => _RegPageState();
}


class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswrodController = TextEditingController();
  /* var _phoneController = new MaskedTextController(mask: '+7 (###) ###-##-##',
  translator: {'#': new RegExp(r'[0-9]')}); */
  TextEditingController _phoneController = TextEditingController();
  var _maskPhoneFormatter = new MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]'),},
    type: MaskAutoCompletionType.lazy
  );
  bool _isLoginChecking = false;
  bool _isPhoneChecking = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _submitButtonActive = true;
  bool _isPrivacyPolicyAgree = false;
  bool _isPrivacyPolicyWarningVisible = false;
  dynamic _loginValidationMsg;
  dynamic _phoneValidationMsg;
  late int _verificationCode;
  Config _config = Config();
  

  Future<dynamic> _checkLogin(login) async {
    final RegExp _cyrillicRegExp = RegExp(r'[А-Яа-яЁё]+');
    _loginValidationMsg = null;

    // sync validation

    if (customValidator.Validator.checkIsTextIsEmpty(login)) {
      _loginValidationMsg = 'Поле не должно быть пустым';
      setState(() {
        
      });
      return null;
    }

    if (login!.length < _config.getMinTextLength) {
      _loginValidationMsg = 'Минимум ${_config.getMinTextLength} символов';
      setState(() {
        
      });
      return null;
    }

    if (customValidator.Validator.checkLanguage(login!, _cyrillicRegExp)){
      _loginValidationMsg = 'Допускается только латиница';
      setState(() {
        
      });
      return null;
    }

    // async validation

    _isLoginChecking = true;
    setState(() {
      
    });
    await Future.delayed(Duration(milliseconds: 1000));
    
    if (await Api.checkLoginIsExist(login)) {
      _loginValidationMsg = 'Такой логин уже используется';
    }
    _isLoginChecking = false;
    setState(() {
      
    });
  }

  Future<dynamic> _checkPhone(phone) async {
    // sync validation
    if(customValidator.Validator.checkIsTextIsEmpty(phone) || phone.length == 1) {
      _phoneValidationMsg = 'Поле не должно быть пустым';
      setState(() {
        
      });
      return null;
    }

    // async validation
    _isPhoneChecking = true;
    setState(() {
      
    });

    await Future.delayed(Duration(milliseconds: 1000));
    if (await Api.checkPhoneIsExist(phone)) {
      _phoneValidationMsg = 'Такой номер уже зарегистрирован';
    }

    _isPhoneChecking = false;
    setState(() {
      
    });
  }

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
  void dispose(){
    _nameController.dispose();
    _surnameController.dispose();
    _loginController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswrodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Регистрация'),
            centerTitle: true,
            leading: BackButton(
              color: Colors.deepPurple[900],
              onPressed: () {
                Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
              },),
          ),
          body: 
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (customValidator.Validator.checkIsTextIsEmpty(text)){
                                  return 'Поле не должно быть пустым';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Имя'
                              ),
                            ),
                            TextFormField(
                              controller: _surnameController,
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (customValidator.Validator.checkIsTextIsEmpty(text)){
                                  return 'Поле не должно быть пустым';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Фамилия'),
                            ),
                            Focus(child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Логин',
                                suffixIcon: _isLoginChecking ? Transform.scale(scale: 0.5, child: CircularProgressIndicator(),) : Tooltip(
                                  message: 'Ваш уникальный никнейм (не почта!),\nкоторый будет идентифицировать вас\nНапример, SlavaLoveEnglish257',
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: Duration(seconds: 5),
                                  child: Icon(Icons.help_outline)
                                )),
                                controller: _loginController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => _loginValidationMsg,
                                ),
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) _checkLogin(_loginController.text);
                                },
                                ),
                              Focus(
                                child: TextFormField(
                                  controller: _phoneController,
                                  inputFormatters: [_maskPhoneFormatter],
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) => _phoneValidationMsg,
                                decoration: InputDecoration(
                                  hintText: '+${_config.getCountryCode} (000) 000-00-00',
                                  labelText: 'Номер телефона',
                                  suffixIcon: _isPhoneChecking ? Transform.scale(scale: 0.5, child: CircularProgressIndicator(),) : null,
                                ),
                                ),
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) _checkPhone(_config.getCountryCode + _maskPhoneFormatter.getUnmaskedText());
                                },
                              ),
                              TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    validator: (text) {
                      if (customValidator.Validator.checkIsTextIsEmpty(text)){
                        return 'Поле не должно быть пустым';
                      }
                      if (text!.length < _config.getMinPasswordLength){
                        return 'Допустимо минимум ${_config.getMinPasswordLength} символов';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      hintText: 'Введите пароль',
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility 
                        : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },)),
                  ),
                  TextFormField(
                    controller: _confirmPasswrodController,
                    keyboardType: TextInputType.text,
                    obscureText: !_confirmPasswordVisible,
                    validator: (text) {
                      if (customValidator.Validator.checkIsTextIsEmpty(text)){
                        return 'Поле не должно быть пустым';
                      }
                      if (_passwordController.text != _confirmPasswrodController.text){
                        return 'Пароли не совпадают';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Подтвердите пароль',
                      hintText: 'Пароль',
                      suffixIcon: IconButton(
                        icon: Icon(_confirmPasswordVisible ? Icons.visibility 
                        : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },)),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(value: _isPrivacyPolicyAgree, 
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrivacyPolicyAgree = value!;
                          if (_isPrivacyPolicyWarningVisible)
                          {
                            _isPrivacyPolicyWarningVisible = false;
                          }
                        });
                      }),
                      RichText(text: TextSpan(
                        text: 'Я соглашаюсь с ',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '\nполитикой конфиденциальности',
                            style: TextStyle(
                              fontSize: 16, color: Colors.deepPurple[900],decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse('https://serverq5.ace-study.ru/privacy_policy'));
                              }
                          )
                        ]))
                    ],
                  ),
                  if (_isPrivacyPolicyWarningVisible)
                  Text('Для регистрации необходимо согласиться с политикой конфиденциальности',
                  style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: _submitButtonActive ? () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isPrivacyPolicyAgree) {
                      setState(() {
                        _submitButtonActive = false;
                        _isPrivacyPolicyWarningVisible = false;
                      });
                      _verificationCode = Random().nextInt(9000) + 1000;
                      Map data = {
                        'name' : _nameController.text.trim().capitalize(),
                        'surname': _surnameController.text.trim().capitalize(),
                        'login': _loginController.text.trim().capitalize(),  
                        'phone' : _config.getCountryCode + _maskPhoneFormatter.getUnmaskedText(),
                        'password' : _passwordController.text,
                        'privacy_policy' : _isPrivacyPolicyAgree,
                      };
                      await Api.send4DigitCode(data['phone'], _verificationCode, true);
                      // print(data);
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => CodePage(
                        data: data,
                        verificationCode: _verificationCode,
                        isFromRegPage: true)));
                        } else {
                          setState(() {
                            _isPrivacyPolicyWarningVisible = true;
                          });
                        }
                    }
                  } :
                  null, 
                  child: Text('Зарегистрироваться'))
                          ]),
                          ),
                    )
                        )
                ],),
            ))
        );
      
  }
}
