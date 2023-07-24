import 'package:flutter/material.dart';

import 'settings.dart';
import 'pages/main/main_page.dart';
import 'pages/vocabulary/vocabularies.dart';
import 'pages/user_settings.dart';

String app_page = 'main';

Map <String, Widget> pages = {
  'main' : MainView(),
  'vocabularies' : VocabulariesView(),
  'settings' : UserSettings(),
};

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}