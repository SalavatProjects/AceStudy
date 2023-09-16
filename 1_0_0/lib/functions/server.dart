
import '../models/vocabulary.dart';
import '../utils/postgres_conn.dart';
import '../models/word_translation.dart';

class Server{

  static List<Vocabulary> getUserVocabularies(List vocabulariesList){
    return vocabulariesList.map((e) => Vocabulary.fromJson(e['dictionary'])).toList();
  }

  static Future<void> insertWordsTranslations(
    int vocabularyId, 
    List<WordTranslation> wordsTranslationsList,
    String vocabularyType) async {
      late String wordLan;
      late String translationLan;
      if (vocabularyType == 'rus_en'){
        wordLan = 'rus';
        translationLan = 'en';
      } else if (vocabularyType == 'en_rus'){
        wordLan = 'en';
        translationLan = 'rus';
      }
      await Connect.open_connection();
      await Connect.connection.transaction((ctx) async {
        await ctx.query(
              'DELETE FROM study_english.dictionaries_words WHERE dictionary_id = ${vocabularyId}'
            );
        for (var wordTranslations in wordsTranslationsList)
        {
                
          await ctx.query(
          'INSERT INTO study_english.word (name, language) SELECT \'${wordTranslations.word}\', \'$wordLan\' WHERE NOT EXISTS (SELECT name FROM study_english.word WHERE name = \'${wordTranslations.word}\')'
          );
          for (var translation in wordTranslations.translationList)
          {
            // print(translation);
            await ctx.query(
              'INSERT INTO study_english.translation (name, language) SELECT \'$translation\', \'$translationLan\' WHERE NOT EXISTS (SELECT name FROM study_english.translation WHERE name = \'$translation\')'
            );
            await ctx.query(
              'DELETE FROM study_english.word_translations WHERE word_id = (SELECT id FROM study_english.word WHERE name = \'${wordTranslations.word}\')'
            );
            await ctx.query(
              'INSERT INTO study_english.word_translations (word_id, translation_id) SELECT (SELECT id FROM study_english.word WHERE name = \'${wordTranslations.word}\' ),(SELECT id FROM study_english.translation WHERE name = \'$translation\')'
            );
            await ctx.query(
              'INSERT INTO study_english.dictionaries_words (dictionary_id, word_id, translation_id) SELECT (SELECT $vocabularyId),(SELECT id FROM study_english.word WHERE name = \'${wordTranslations.word}\'),(SELECT id FROM study_english.translation WHERE name = \'$translation\')'
            );
           }
        }
        // Удаление дубликатов
        await ctx.query(
          'DELETE FROM study_english.dictionaries_words a USING ('+
          'SELECT MIN(CTID) AS CTID, dictionary_id,word_id, translation_id FROM study_english.dictionaries_words '+
          'GROUP BY (dictionary_id, word_id, translation_id) HAVING COUNT(*) > 1) b '+
          'WHERE a.dictionary_id = b.dictionary_id '+
          'AND a.word_id = b.word_id '+
          'AND a.translation_id = b.translation_id '+
          'AND a.CTID <> b.CTID'
        );
        await ctx.query(
          'UPDATE study_english.dictionary SET words_count = (SELECT COUNT(DISTINCT word_id) FROM study_english.dictionaries_words WHERE dictionary_id = $vocabularyId), updated_at = current_timestamp(3) WHERE id = ${vocabularyId}'
        );
      });
      
  }

  /* static bool checkIfWordExist(List<WordTranslation> checkList, String word){
    for (var checkElem in checkList){
      if (word == checkElem.word){
        return true;
      }
    }
    return false;
  } */

  static Future<List<WordTranslation>> getWordsFromVocabulary(int vocabularyId, String vocabularyType) async {
    await Connect.open_connection();
    List<List<dynamic>> result = await Connect.connection.query(
    'SELECT w.name, t.name FROM study_english.word as w INNER JOIN study_english.dictionaries_words as dw ON w.id = dw.word_id INNER JOIN study_english.translation as t ON dw.translation_id = t.id WHERE dw.dictionary_id = $vocabularyId');
    List<WordTranslation> wordsTranslations = [];
    List<String> words = [];
    for (var elem in result){
      if(!words.contains(elem[0])){
        words.add(elem[0]);
      }
    }
    for (var word in words){
      List<String> translations = [];
      for (var elem in result){
        if(word == elem[0]){
          translations.add(elem[1]);
        }
      }
      wordsTranslations.add(WordTranslation(
        word: word, 
        translationList: List.of(translations), 
        vocabularyType: vocabularyType));
        translations.clear();
    }
    // print(result);
    // print(wordsTranslations);
    return wordsTranslations;
  }
}