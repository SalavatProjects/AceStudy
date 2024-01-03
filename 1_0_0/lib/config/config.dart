import 'package:flutter/material.dart';

import '../pages/main_page.dart';
import '../pages/vocabularies_page.dart';
import '../pages/settings_page.dart';
import '../pages/train_page.dart';
import '../pages/profile_page.dart';
import '../pages/user_statistics_page.dart';
import '../pages/guide_page.dart';
import '../pages/teacher_groups.dart';
import '../pages/student_groups.dart';

class Config {
  
  static String _app_page = 'train';

  late final int _minAvailableWordsInVocabulary;
  late final int _maxAvailableTranslations;
  late final int _maxAvailablTextLength;
  late final int _maxAvailableTranslateTextLength;
  late final int _maxAvailableWordsInVocabulary;
  late final int _minTextLength;
  late final int _minPasswordLength;
  late final int _price;

  final Map <String, Widget> _pages = {
  'main' : MainView(),
  'vocabularies' : VocabulariesView(),
  'settings' : UserSettings(),
  'train' : TrainPage(),
  'profile' : ProfilePage(),
  'user_statistics' : UserStatisticsPage(),
  'guide' : GuidePage(),
  'groups_teacher' : TeacherGroups(),
  'groups_student' : StudentGroups(),
  };
  final List<String> _pagesName = [
    'main',
    'vocabularies',
    'settings',
    'train',
    'profile',
    'user_statistics',
    'guide',
    'groups_teacher',
    'groups_student',
  ];

  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Config._internal();

  void getConfigFromJson(Map<String, dynamic> json) {
    try {
    _minAvailableWordsInVocabulary = json['min_available_words_in_vocabulary'];
    _maxAvailableTranslations = json['max_available_translations'];
    _maxAvailablTextLength = json['max_available_text_length'];
    _maxAvailableTranslateTextLength = json['max_available_translate_text_length'];
    _maxAvailableWordsInVocabulary = json['max_available_words_in_vocabulary'];
    _minTextLength = json['min_text_length'];
    _minPasswordLength = json['min_password_length'];
    _price = json['price'];
    } catch(e){
      print(e);
    }
    
  }

  String get getAppPage => _app_page;
  int get getMinAvailableWordsInVocabulary => _minAvailableWordsInVocabulary;
  int get getMaxAvailableTranslations => _maxAvailableTranslations;
  int get getMaxAvailablTextLength => _maxAvailablTextLength;
  int get getMaxAvailableWordsInVocabulary => _maxAvailableWordsInVocabulary;
  int get getMaxAvailableTranslateTextLength => _maxAvailableTranslateTextLength;
  int get getMinTextLength => _minTextLength;
  int get getMinPasswordLength => _minPasswordLength;
  int get getPrice => _price;
  Map<String, Widget> get getPages => _pages;

  set setPageName(String value){
    if (_pagesName.contains(value)){
      _app_page = value;
    }
  }

  void printConfig() {
    print('String app_page: $_app_page');
    print('int minAvailableWordsInVocabulary: $_minAvailableWordsInVocabulary');
    print('int maxAvailableTranslations: $_maxAvailableTranslations');
    print('int maxAvailablTextLength: $_maxAvailablTextLength');
    print('int maxAvailableTranslateTextLength: $_maxAvailableTranslateTextLength');
    print('int maxAvailableWordsInVocabulary: $_maxAvailableWordsInVocabulary');
    print('int minTextLength: $_minTextLength');
    print('int minPasswordLength: $_minPasswordLength');
    print('int price: $_price');
    print('Map <String, Widget> pages: $_pages');
    print('List<String> pagesName: $_pagesName');
  }
}

