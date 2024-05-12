part of 'group_vocabularies_bloc.dart';

@immutable
sealed class GroupVocabulariesState {}

final class GroupVocabulariesInitial extends GroupVocabulariesState {}

final class GroupVocabulariesIsNotReady extends GroupVocabulariesState {}

final class GroupVocabulariesIsReady extends GroupVocabulariesState {
  List<Vocabulary> vocabularies;
  GroupVocabulariesIsReady({required this.vocabularies});
}