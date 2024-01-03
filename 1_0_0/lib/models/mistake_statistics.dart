import 'word.dart';
import '../functions/from_json.dart';

class MistakeStatistics{
  int attemptNumber;
  int vocabularyId;
  int mistakesCount;
  List<Word>? words;
  
  MistakeStatistics({
    required this.attemptNumber,
    required this.vocabularyId,
    required this.mistakesCount,
    required this.words,
  });
  
  factory MistakeStatistics.fromJson(Map<String, dynamic> json){
    return MistakeStatistics(
      attemptNumber: json['attempt_number'], 
      mistakesCount: json['mistakes_count'],
      vocabularyId: json['dictionary_id'],
      words: json['words'].isNotEmpty ? FromJson.getWords(json['words']) : null,
      );
  }

  int get getAttemptNumber => attemptNumber;
  int get getVocabularyId => vocabularyId;
  int get getMistakesCount => mistakesCount;
  List<Word>? get getWords => words;
  

  @override
  String toString() {
    return 'MistakeStatistics: int attmeptNumber $attemptNumber, int vocabularyId $vocabularyId, int mistakesCount $mistakesCount, List<Word>? words $words';
  }
}