import 'word.dart';
import '../functions/from_json.dart';
import '../config/config.dart';

class Vocabulary{
  int id;
  String name;
  String? icon;
  String typeSlug;
  String type;
  int wordsCount;
  List<Word> words;
  int attemptNumber;
  int translationsCount;
  Vocabulary({
    required this.id,
    required this.name,
    required this.icon,
    required this.typeSlug,
    required this.type,
    required this.wordsCount,
    required this.words,
    required this.attemptNumber,
    required this.translationsCount,
  });
  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    late String currentType;
    switch (json['type']) {
      case 'en_rus':
        currentType = 'Ан/рус';
        break;
      case 'rus_en':
        currentType = 'Рус/ан';
        break;
    }
    return Vocabulary(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    typeSlug: json['type'],
    type: currentType,
    wordsCount: json['words_count'],
    words: FromJson.getWords(json['words']),
    attemptNumber: json['attempt_number'],
    translationsCount: json['translations_count']
    );
  }

  int get getId => id;
  String get getName => name;
  String? get getIcon => icon;
  String get getTypeSlug => typeSlug;
  String get getType => type;
  int get getWordsCount => wordsCount;
  List<Word> get getWords => words;
  int get getAttemptNumber => attemptNumber;
  int get getTranslationsCOunt => translationsCount;
  
  @override
  String toString() {
    return 'Vocabulary: int id $id, String name $name, String? icon $icon, String type $type, int words_count $wordsCount, '+
    'int attemptNumber $attemptNumber, int translationsCount $translationsCount, List<Word> words $words;';
  }

  

}