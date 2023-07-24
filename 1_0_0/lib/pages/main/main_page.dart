import 'package:flutter/material.dart';

import 'package:ace_study/settings.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Center(child: Text('${settings_language[app_language]!.welcome} {user_name}!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500,
             color: Colors.blueGrey[800]),),)
          ],),
      );
  }
}