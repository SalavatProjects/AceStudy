import 'package:ace_study/utils/settings.dart';
import 'package:flutter/material.dart';


class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

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
          ListTile(title: const Text('Русский'),
          leading: Radio<String>(
            groupValue: app_language,
            value: 'ru',
            onChanged: (String? value) {
              setState(() {
                app_language = value!;
              });
            }),
            ),
            ListTile(title: const Text('English'),
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