part of 'word_translation_bloc.dart';

@immutable
abstract class WordTranslationState {}

class WordTranslationInitial extends WordTranslationState {}

class WordTranslationsIsReady extends WordTranslationState {
  List<WordTranslation> wordTranslationsLoaded;
  WordTranslationsIsReady({required this.wordTranslationsLoaded});
}