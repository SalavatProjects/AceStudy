part of 'voc_bloc.dart';

@immutable
abstract class VocPageState {}

class VocPageInitial extends VocPageState {}

class VocabulariesIsNotReady extends VocPageState {}

class VocabulariesIsReady extends VocPageState{
  List<Vocabulary> vocabularies;
  VocabulariesIsReady({required this.vocabularies});
}