import 'package:flutter/material.dart';

import '../utils/validators.dart' as customValidator;
import '../config/config.dart';
import '../functions/api.dart';
import '../functions/modify.dart';
import '../home.dart';
import '../models/user.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  bool _isLoginChecking = false;
  dynamic _loginValidationMsg;
  bool _submitButtonActive = true;
  User _user = User();
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
    
    if (await Api.checkUserLoginIsExist(_user.getId, login)) {
      _loginValidationMsg = 'Такой логин уже используется';
    }
    _isLoginChecking = false;
    setState(() {
      
    });
  }

  void initState() {
    super.initState();
    _nameController.text = _user.getName;
    _surnameController.text = _user.getSurname;
    _loginController.text = _user.getLogin;
  }

    @override
  void dispose(){
    _nameController.dispose();
    _surnameController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование профиля'),
        centerTitle: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                                  child: Icon(Icons.help_outline),
                                )),
                                controller: _loginController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => _loginValidationMsg,
                                ),
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) _checkLogin(_loginController.text);
                                },
                                ),
                                SizedBox(height: 10,),
                                Text('Если нужно изменить номер телефона, обратитесь в тех. поддержку'),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: _submitButtonActive ? () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _submitButtonActive = false;
                      });
                      // print(data);
                      await Api.updateUser(_user.getId, 
                      _nameController.text.trim().capitalize(), 
                      _surnameController.text.trim().capitalize(), 
                      _loginController.text.trim());
                      _user.getUserDataFromJson(await Api.getJsonUserData(_user.getId));
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => HomeView()));
                    }
                  } :
                  null, 
                  child: Text('Сохранить'))
                          ]),
                          ),
                    )
                        )
            ]),
            )
            ),
    );
  }
}