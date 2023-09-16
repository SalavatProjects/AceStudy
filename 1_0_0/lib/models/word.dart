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
      translations: json['']
    );
  }

  /* set setName(String name) => super.name = name;

  set setFull(Map <String, dynamic> json) {
    super.id = json['id'];
    super.name = json['name'];
    super.language = json['language'];
    this.translations = json[''];
  } */
}