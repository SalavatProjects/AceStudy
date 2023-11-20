import 'package:flutter/material.dart';

import '../pages/main_page.dart';
import '../pages/vocabularies_page.dart';
import '../pages/settings_page.dart';
import '../pages/train_page.dart';

class Config {
  
  static String _app_page = 'main';
  static const int _minAvailableWordsInVocabulary = 3;
  static const int _maxAvailableTranslations = 4;
  static const int _maxAvailablTextLength = 45;
  static const int _maxAvailableTranslateTextLength = 17;
  static const int _maxAvailableWordsInVocabulary = 120;
  static const int _minTextLength = 4;
  static const int _minPasswordLength = 8;
  static Map <String, Widget> _pages = {
  'main' : MainView(),
  'vocabularies' : VocabulariesView(),
  'settings' : UserSettings(),
  'train' : TrainPage(),
  };
  static const List<String> _pagesName = [
    'main',
    'vocabularies',
    'settings',
    'train'
  ];

  static String get getAppPage => _app_page;
  static int get getMinAvailableWordsInVocabulary => _minAvailableWordsInVocabulary;
  static int get getMaxAvailableTranslations => _maxAvailableTranslations;
  static int get getMaxAvailablTextLength => _maxAvailablTextLength;
  static int get getMaxAvailableWordsInVocabulary => _maxAvailableWordsInVocabulary;
  static int get getMaxAvailableTranslateTextLength => _maxAvailableTranslateTextLength;
  static int get getMinTextLength => _minTextLength;
  static int get getMinPasswordLength => _minPasswordLength;
  static Map<String, Widget> get getPages => _pages;

  static set setPageName(String value){
    if (_pagesName.contains(value)){
      _app_page = value;
    }
  }
}

