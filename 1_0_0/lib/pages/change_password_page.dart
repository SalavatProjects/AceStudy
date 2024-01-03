import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../config/config.dart';
import '../functions/api.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  String phone;
  ChangePasswordPage({super.key,
  required this.phone});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswrodController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isSubmitButtonActive = true;
  Config _config = Config();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Восстановление пароля'),
      centerTitle: true,
      automaticallyImplyLeading: false,),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,
            child: Text('Придумайте новый пароль'),),
            Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    validator: (text) {
                      if (Validator.checkIsTextIsEmpty(text)){
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
                      if (Validator.checkIsTextIsEmpty(text)){
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
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: _isSubmitButtonActive ? () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isSubmitButtonActive = false;
                      });
                      await Api.saveUserPassword(widget.phone, _passwordController.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  }
                  : null, 
                  child: _isSubmitButtonActive ? 
                  Text('Сменить пароль') :
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator())) 
                    ]),
                    ),
                    ))
          ]),
          )
          ),
    );
  }
}