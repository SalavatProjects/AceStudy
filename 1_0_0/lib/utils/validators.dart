import '../config/config.dart';

class Validator {
  static Config _config = Config();

  static bool checkIsTextIsEmpty(String? text) =>
    (text == null || text.isEmpty) ? true : false;

  static bool checkLanguage(String text,RegExp languageRegExp) => 
    languageRegExp.hasMatch(text) ? true : false;
  
  static bool checkTextLength(String text) =>
    text.length <= _config.getMaxAvailablTextLength ? false : true;
  
  static bool checkTranslateLength(String text) =>
    text.length <= _config.getMaxAvailableTranslateTextLength ? false : true;
}