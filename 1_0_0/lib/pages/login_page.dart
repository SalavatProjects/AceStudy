import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'reg_page.dart';
import 'phone_page.dart';
import '../utils/validators.dart';
import '../functions/authorization.dart';
import '../functions/api.dart';
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
  bool _isErrorVisible = false;
  bool _isErrorPhoneVisible = false;
  bool _isAuthButtonActive = true;

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
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              _isErrorVisible ? 
              SizedBox(height: 20,
              child: Text('Неверны либо телефон, либо пароль',
              style: TextStyle(color: Colors.red),),)
              :
              SizedBox(height: 20,),
              _isErrorPhoneVisible ? 
              SizedBox(height: 20,
              child: Text('Такой номер телефона не зарегистирован',
              style: TextStyle(color: Colors.red),),)
              :
              SizedBox(height: 20,),
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
                        ElevatedButton(onPressed: _isAuthButtonActive ? () async {
                          if (_formKey.currentState!.validate()){
                            setState(() {
                              _isAuthButtonActive = false;
                            });
                            // print(await Api.logIn(_phoneController.unmasked, _passwordController.text));
                          if (await Api.checkPhoneIsExist(_phoneController.unmasked))
                          {
                            if (await Api.logIn(_phoneController.unmasked, _passwordController.text))
                          {
                            await Authorization.login();
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('userId', await Api.getUserId(_phoneController.unmasked));
                            Navigator.push(
                            context, MaterialPageRoute(builder: (context) => App())); 
                            } else {
                            setState(() {
                              _isErrorVisible = true;
                              _isAuthButtonActive = true;
                            });
                          }
                          } else {
                            setState(() {
                              _isErrorPhoneVisible = true;
                              _isAuthButtonActive = true;
                            });
                            
                          }
                          
                          }      
                        } : null,
                        child: _isAuthButtonActive ? Text('Авторизоваться') :
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())),
                        TextButton(onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => PhonePage()));
                        }, 
                        child: Text('Забыли пароль?'))
                      ],
                    ),
                  ),
                ))
            ]),
        ),
      ),
    ),
      );
  }
}