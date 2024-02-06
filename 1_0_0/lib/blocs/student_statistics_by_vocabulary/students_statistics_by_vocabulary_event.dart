part of 'students_statistics_by_vocabulary_bloc.dart';

@immutable
sealed class StudentsStatisticsByVocabularyEvent {}

class StudentsStatisticsByVocabularyGettingReadyEvent extends StudentsStatisticsByVocabularyEvent {
  int groupId;
  Vocabulary vocabulary;
  StudentsStatisticsByVocabularyGettingReadyEvent({
    required this.groupId,
    required this.vocabulary});
}