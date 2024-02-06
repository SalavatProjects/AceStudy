part of 'students_statistics_by_vocabulary_bloc.dart';

@immutable
sealed class StudentsStatisticsByVocabularyState {}

final class StudentsStatisticsByVocabularyInitial extends StudentsStatisticsByVocabularyState {}

final class StudentsStatisticsByVocabularyIsNotReady extends StudentsStatisticsByVocabularyState {}

final class StudentsStatisticsByVocabularyIsReady extends StudentsStatisticsByVocabularyState {
  Map statistics;
  StudentsStatisticsByVocabularyIsReady({required this.statistics});
}