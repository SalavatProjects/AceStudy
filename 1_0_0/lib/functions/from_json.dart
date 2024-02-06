import '../models/vocabulary.dart';
import '../models/word.dart';
import '../models/translation.dart';
import '../models/user_mistake_statistics.dart';
import '../models/group.dart';
import '../models/group_member.dart';

class FromJson {

  static List<Vocabulary> getVocabularies(List vocabulariesList){
    return vocabulariesList.map((e) => Vocabulary.fromJson(e['dictionary'])).toList();
  }

  static List<Word> getWords(List wordsList){
    return wordsList.map((e) => Word.fromJson(e['word'])).toList();
  }

  static List<Translation> getTranslations(List translationsList){
    return translationsList.map((e) => Translation.fromJson(e['translation'])).toList();
  }

  static List<Map<String, dynamic>> getVocabulariesMistakeStatistic(List statistics){
    List<Map<String, dynamic>> result = [];
    statistics.forEach((element) {
      
      int userId = element['user_id']; 
      Vocabulary voc = Vocabulary.fromJson(element['dictionary']);
      List<UserMistakeStatistics> mistakeStatisticsList = [];
      element['attempts'].forEach((attempt) {
        mistakeStatisticsList.add(UserMistakeStatistics.fromJson(attempt));
      });
      result.add({
        'user_id' : userId,
        'vocabulary': voc,
        'mistake_statistics' : mistakeStatisticsList
        });
    });
    return result;
  }

  static List<Group> getGroups(List groupsList) {
    return groupsList.map((e) => Group.fromJson(e)).toList();
  } 

  static List<GroupMember> getParticipants(List participantsList) {
    return participantsList.map((e) => GroupMember.fromJson(e)).toList();
  }
  
  static Map getStudentsStatisticsByVocabularyFromJson(Map statistics) {
    Map result = {};
    result['group_id'] = statistics['group_id'];
    result['vocabulary_id'] = statistics['vocabulary_id'];
    result['vocabulary_translations_count'] = statistics['vocabulary_translations_count'];
    
    List studentsList = [];
    statistics['students'].forEach((student) {
      List<UserMistakeStatistics> userMistakeStatisticsList = [];
      student['student_attempts'].forEach((attempt){
       userMistakeStatisticsList.add(UserMistakeStatistics.fromJson(attempt)); 
      });
      
      studentsList.add({
        'student': GroupMember.fromJson(student),
        'attempts': userMistakeStatisticsList,
      });
    });
    result['students'] = studentsList;
    
    return result;
  }
}