import 'package:ace_study/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config.dart';
import '../page_bloc/page_bloc.dart';

class UserSettings extends StatefulWidget {
  UserSettings({super.key});

  @override
  State<UserSettings> createState() => UserSettingsState();
}

class UserSettingsState extends State<UserSettings> {

  
  // String _languageValue = app_language;

  // void checkRadio(String value){
  //   setState(() {
  //     _languageValue = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(title: Text('Русский'),
          leading: Radio<String>(
            groupValue: app_language,
            value: 'ru',
            onChanged: (String? value) {
              setState(() {
                app_language = value!;
              });
            }),
            ),
            ListTile(title: Text('English'),
            leading: Radio<String>(
            groupValue: app_language,
            value: 'en',
            onChanged: (String? value) {
              setState(() {
                app_language = value!;
              });
              
            }),
            ),
        ]
        ),
    );
  }
}