part of 'voc_page_bloc.dart';

@immutable
abstract class VocPageState {}

class VocPageInitial extends VocPageState {}

class VocabulariesIsReady extends VocPageState{
  List vocabularies;
  VocabulariesIsReady({required this.vocabularies});
}