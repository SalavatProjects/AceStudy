// word length 17 symbols

import 'package:flutter/material.dart';

import '../pages/main_page.dart';
import '../pages/vocabularies/vocabularies_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/train/train_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/statistics/user_statistics_page.dart';
import '../pages/guide/guide_page.dart';
import '../pages/groups/teacher/teacher_groups.dart';
import '../pages/groups/student/student_groups_page.dart';
import '../pages/statistics/teacher/students_groups_statistics.dart';

class Config {
  
  static String _app_page = 'train';
  static String _countryCode = '7';

  late final int _minAvailableWordsInVocabulary;
  late final int _maxAvailableTranslations;
  late final int _maxAvailablWordLength;
  late final int _maxAvailableTranslateWordLength;
  late final int _maxAvailableTranslatePhraseLength;
  late final int _maxAvailableTranslateLongPhraseLength;
  late final int _maxAvailableWordsInVocabulary;
  late final int _maxTextLength;
  late final int _minTextLength;
  late final int _minPasswordLength;
  late final String _technicalSupport;
  late final String _telegramGroup;
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
  'groups_student' : StudentGroupsPage(),
  'students_statistics' : StudentsGroupsStatistics(),
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
    'students_statistics',
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
    _maxAvailablWordLength = json['max_available_word_length'];
    _maxAvailableTranslateWordLength = json['max_available_translate_word_length'];
    _maxAvailableTranslatePhraseLength = json['max_available_translate_phrase_length'];
    _maxAvailableTranslateLongPhraseLength = json['max_available_translate_long_phrase_length'];
    _maxAvailableWordsInVocabulary = json['max_available_words_in_vocabulary'];
    _maxTextLength = json['max_text_length'];
    _minTextLength = json['min_text_length'];
    _minPasswordLength = json['min_password_length'];
    _technicalSupport = json['technical_support'];
    _telegramGroup = json['telegram_group'];
    _price = json['price'];
    } catch(e){
      print(e);
    }
    
  }

  String get getAppPage => _app_page;
  String get getCountryCode => _countryCode;
  int get getMinAvailableWordsInVocabulary => _minAvailableWordsInVocabulary;
  int get getMaxAvailableTranslations => _maxAvailableTranslations;
  int get getMaxAvailableWordLength => _maxAvailablWordLength;
  int get getMaxAvailableWordsInVocabulary => _maxAvailableWordsInVocabulary;
  int get getMaxAvailableTranslateWordLength => _maxAvailableTranslateWordLength;
  int get getMaxAvailableTranslatePhraseLength => _maxAvailableTranslatePhraseLength;
  int get getMaxAvailableTranslateLongPhraseLength => _maxAvailableTranslateLongPhraseLength;
  int get getMaxTextLength => _maxTextLength;
  int get getMinTextLength => _minTextLength;
  int get getMinPasswordLength => _minPasswordLength;
  String get getTechnicalSupport => _technicalSupport;
  String get getTelegramGroup => _telegramGroup;
  int get getPrice => _price;
  Map<String, Widget> get getPages => _pages;

  set setPageName(String value){
    if (_pagesName.contains(value)){
      _app_page = value;
    }
  }

  void printConfig() {
    print('String app_page: $_app_page');
    print('String countryCode: $_countryCode');
    print('int minAvailableWordsInVocabulary: $_minAvailableWordsInVocabulary');
    print('int maxAvailableTranslations: $_maxAvailableTranslations');
    print('int maxAvailablWordLength: $_maxAvailablWordLength');
    print('int maxAvailableTranslateWordLength: $_maxAvailableTranslateWordLength');
    print('int maxAvailabaleTranslatePhraseLength: $_maxAvailableTranslatePhraseLength');
    print('int maxAvailableTranslateLongPhraseLength: $_maxAvailableTranslateLongPhraseLength');
    print('int maxAvailableWordsInVocabulary: $_maxAvailableWordsInVocabulary');
    print('int maxTextLength: $_maxTextLength');
    print('int minTextLength: $_minTextLength');
    print('int minPasswordLength: $_minPasswordLength');
    print('String technicalSupport: $_technicalSupport');
    print('String telegramGroup: $_telegramGroup');
    print('int price: $_price');
    print('Map <String, Widget> pages: $_pages');
    print('List<String> pagesName: $_pagesName');
  }
}

