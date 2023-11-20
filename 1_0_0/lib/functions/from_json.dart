import '../models/vocabulary.dart';
import '../models/word.dart';
import '../models/translation.dart';

class FromJson {

  static List<Vocabulary>? getUserVocabularies(List? vocabulariesList){
    if (vocabulariesList != null)
    {
      return vocabulariesList.map((e) => Vocabulary.fromJson(e['dictionary'])).toList();
    } else {
      return null;
    }
    
  }

  static List<Word> getWords(List wordsList){
    return wordsList.map((e) => Word.fromJson(e['word'])).toList();
  }

  static List<Translation> getTranslations(List translationsList){
    return translationsList.map((e) => Translation.fromJson(e['translation'])).toList();
  }

}