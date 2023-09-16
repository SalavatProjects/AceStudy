import '../config/config.dart';

class Validator {
  
  static bool checkIsTextIsEmpty(String? text) =>
    (text == null || text.isEmpty) ? true : false;

  static bool checkLanguage(String text,RegExp languageRegExp) => 
    languageRegExp.hasMatch(text) ? true : false;
  
  static bool checkTextLength(String text) =>
    text.length <= Config.maxAvailablTextLength ? false : true;
}