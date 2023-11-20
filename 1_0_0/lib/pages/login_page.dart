import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

import '../utils/validators.dart';
import 'reg_page.dart';
import '../functions/authorization.dart';
import '../../app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _phoneController = new MaskedTextController(mask: '+# (###) ###-##-##',
  translator: {'#': new RegExp(r'[0-9]')});
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  void dispose(){
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Авторизация'),
      centerTitle: true,
      automaticallyImplyLeading: false,),
    body: Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Center(
              child: SizedBox(
                width: 300,
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
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      validator: (text) {
                        if (Validator.checkIsTextIsEmpty(text)){
                          return 'Поле не должно быть пустым';
                        }
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegPage()));
                      }, 
                      child: Text('Зарегистрироваться')),
                    ),
                    ElevatedButton(onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        // print(_phoneController.unmasked);
                      await Authorization.login();
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => App())); 
                      }
                    },
                    child: Text('Авторизоваться')),
                    TextButton(onPressed: () {}, 
                    child: Text('Забыли пароль?'))
                  ],
                ),
              ),
            ))
        ]),
    ),
      );
  }
}