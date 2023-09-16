part of 'word_translation_bloc.dart';

@immutable
abstract class WordTranslationEvent {}

class WordTranslationIsGettingReadyEvent extends WordTranslationEvent{
  int vocabularyId;
  String vocabularyType;
  WordTranslationIsGettingReadyEvent({
    required this.vocabularyId,
    required this.vocabularyType});
}