import 'package:flutter/material.dart';

import '../pages/main_page.dart';
import '../pages/vocabularies_page.dart';
import '../pages/settings_page.dart';

class Config {
  
  static String app_page = 'main';

  static int minAvailableWordsInVocabulary = 3;

  static int maxAvailableTranslations = 4;

  static int maxAvailablTextLength = 50;

  static Map <String, Widget> pages = {
  'main' : const MainView(),
  'vocabularies' : const VocabulariesView(),
  'settings' : const UserSettings(),
  };

}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}