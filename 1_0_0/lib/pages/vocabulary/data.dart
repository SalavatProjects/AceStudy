import 'package:flutter/material.dart';

// import 'vocabularies.dart';
// import 'vocabulary.dart';
// import 'words.dart';
// import 'word.dart';

// Map<String, Widget> vocabulary_pages = {
//   'vocabularies' : VocabulariesView(),
//   'vocabulary' : VocabularyView(),
//   'words' : WordsView(),
//   'word' : WordView(),
// };

late Vocabularies vocabularies;

class Vocabularies {
  final List<Vocabulary> data;
  Vocabularies({required this.data});

  factory Vocabularies.fromJson(List elements) {
    final data = elements.map<Vocabulary>((e) => Vocabulary.fromJson(e['dictionary'])).toList();
    return Vocabularies(data: data);
  }

  @override
  String toString() {
    return 'Vocabularies: List ${data}';
  }
}

class Vocabulary {
  int id;
  String name;
  String? icon;
  String type;
  int words_count;
  Vocabulary({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.words_count,
  });
  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    late String current_type;
    switch (json['type']) {
      case 'en_rus':
        current_type = 'Ан/рус';
        break;
      case 'rus_en':
        current_type = 'Рус/ан';
        break;
    }
    return Vocabulary(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    type: current_type,
    words_count: json['words_count']);
  }

  @override
  String toString() {
    return 'Vocabulary: int id ${id}, String name ${name}, String? icon ${icon}, String type ${type}, int words_count ${words_count}';
  }

}

class Word {
  String word;
  List<String> translations;
  
  Word({
    required this.word,
    required this.translations
  });
}

late String vocabularyName;
late String? vocabularyIcon;

late List<Word> word_translations;