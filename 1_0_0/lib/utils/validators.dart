import '../config/config.dart';

class Validator {
  
  static bool checkIsTextIsEmpty(String? text) =>
    (text == null || text.isEmpty) ? true : false;

  static bool checkLanguage(String text,RegExp languageRegExp) => 
    languageRegExp.hasMatch(text) ? true : false;
  
  static bool checkTextLength(String text) =>
    text.length <= Config.getMaxAvailablTextLength ? false : true;
  
  static bool checkTranslateLength(String text) =>
    text.length <= Config.getMaxAvailableTranslateTextLength ? false : true;
}