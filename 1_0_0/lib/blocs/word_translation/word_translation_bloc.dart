import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/word_translation.dart';
import '../../functions/server.dart';

part 'word_translation_event.dart';
part 'word_translation_state.dart';



class WordTranslationBloc extends Bloc<WordTranslationEvent, WordTranslationState> {
  WordTranslationBloc() : super(WordTranslationInitial()) {
    on<WordTranslationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<WordTranslationIsGettingReadyEvent>((event, emit) async {
      List<WordTranslation> wordTranslations = await Server.getWordsFromVocabulary(event.vocabularyId, event.vocabularyType);
      emit(WordTranslationsIsReady(wordTranslationsLoaded: wordTranslations));
    });
  }
}
