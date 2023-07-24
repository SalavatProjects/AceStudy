String app_language = 'ru';

class AppWord {
  String welcome;
  String main;
  String my_vocabularies;
  String my_groups;
  String settings;
  String main_page_title;
  String vocabularies_page_title;
  String settings_page_title;
  String create_vocabulary;

  AppWord({
    required this.welcome,
    required this.main,
    required this.my_vocabularies,
    required this.my_groups,
    required this.settings,
    required this.main_page_title,
    required this.vocabularies_page_title,
    required this.settings_page_title,
    required this.create_vocabulary
  });
}

Map <String, AppWord> settings_language = {
  'ru' : AppWord(
    welcome: 'Добро пожаловать, ',
    main: 'Главная',
    my_vocabularies: 'Мои словари',
    my_groups: 'Мои группы',
    settings: 'Настройки',
    main_page_title: 'AceStudy',
    vocabularies_page_title: 'Мои словари',
    settings_page_title: 'Настройки',
    create_vocabulary: 'Создать словарь'
  ),
  'en' : AppWord(
    welcome: 'Welcome, ',
    main: 'Main',
    my_vocabularies: 'My vocabularies',
    my_groups: 'My groups',
    settings: 'Settings',
    main_page_title: 'AceStudy',
    vocabularies_page_title: 'My vocabularies',
    settings_page_title: 'Settings',
    create_vocabulary: 'Create vocabulary')
};
