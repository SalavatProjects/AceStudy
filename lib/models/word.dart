import '../functions/from_json.dart';
import 'translation.dart';

class Word{
  int id;
  String name;
  String language;
  List<Translation> translations;
  
  Word({
    required this.id,
    required this.name,
    required this.language,
    required this.translations
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      name: json['name'],
      language: json['language'],
      translations: FromJson.getTranslations(json['translations']),
    );
  }

  int get getId => id;
  String get getName => name;
  String get getLanguage => language;
  List<Translation> get getTranslations => translations;

  @override
  String toString(){
    return 'Word: int id: $id, String name: $name, String language: $language, '+
    'List<Translation> translations $translations';
  }
}