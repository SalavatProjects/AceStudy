import 'word.dart';
import '../functions/from_json.dart';

class UserMistakeStatistics{
  int userId;
  int attemptNumber;
  int vocabularyId;
  int mistakesCount;
  List<Word>? words;
  
  UserMistakeStatistics({
    required this.userId,
    required this.attemptNumber,
    required this.vocabularyId,
    required this.mistakesCount,
    required this.words,
  });
  
  factory UserMistakeStatistics.fromJson(Map<String, dynamic> json){
    return UserMistakeStatistics(
      userId: json['user_id'],
      attemptNumber: json['attempt_number'], 
      mistakesCount: json['mistakes_count'],
      vocabularyId: json['dictionary_id'],
      words: json['words'].isNotEmpty ? FromJson.getWords(json['words']) : null,
      );
  }

  int get getUserId => userId;
  int get getAttemptNumber => attemptNumber;
  int get getVocabularyId => vocabularyId;
  int get getMistakesCount => mistakesCount;
  List<Word>? get getWords => words;
  

  @override
  String toString() {
    return 'UserMistakeStatistics: int userId $userId, int attmeptNumber $attemptNumber, int vocabularyId $vocabularyId, int mistakesCount $mistakesCount, List<Word>? words $words';
  }
}