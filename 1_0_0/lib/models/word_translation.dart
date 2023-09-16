class WordTranslation {
  String word;
  List<String> translationList;
  String vocabularyType;

  WordTranslation({
    required this.word,
    required this.translationList,
    required this.vocabularyType
  });
  
  @override
  String toString(){
    return 'WordTranslation\nString word: $word\nList<String> translationList $translationList\n\n';
  }
}