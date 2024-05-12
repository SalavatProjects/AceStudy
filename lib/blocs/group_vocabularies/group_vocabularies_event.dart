part of 'group_vocabularies_bloc.dart';

@immutable
sealed class GroupVocabulariesEvent {}

class GroupVocabulariesGettingReadyEvent extends GroupVocabulariesEvent{
  List<Vocabulary> vocabularies;
  GroupVocabulariesGettingReadyEvent({required this.vocabularies});
}