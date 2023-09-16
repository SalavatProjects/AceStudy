import 'package:ace_study/blocs/test/test_bloc.dart';
import 'package:ace_study/blocs/word_translation/word_translation_bloc.dart';
import 'package:ace_study/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/word_translation.dart';
import '../utils/validators.dart';
import '../functions/server.dart';
import '../app.dart';
import '../widgets/flushbar.dart';

class WordsView extends StatefulWidget {
  int vocabulary_id;
  String vocabulary_type;
  WordsView(
      {super.key, required this.vocabulary_id, required this.vocabulary_type});

  @override
  State<WordsView> createState() => WordsViewState();
}

class WordsViewState extends State<WordsView> {
  final TextEditingController _word_controller = TextEditingController();
  final TextEditingController _translation_controller = TextEditingController();
  bool _submit_button_active = false;
  final bool _show_add_translation_button = true;
  final _formKey_for_word = GlobalKey<FormState>();
  final _formKey_for_translation = GlobalKey<FormState>();
  final RegExp _latinRegExp = RegExp(r'[a-zA-Z]+');
  final RegExp _cyrillicRegExp = RegExp(r'[А-Яа-яЁё]+');
  List<String> _currentTranslationList = [];
  final List<String> _currentTranslationListWithDuplicates = [];
  List<WordTranslation> _wordsTranslationsList = [];
  // WordTranslationBloc _wordsTranslationsBloc = WordTranslationBloc();

  @override
  void initState() {
    super.initState();
    // _wordsTranslationsBloc = WordTranslationBloc();
    // _wordsTranslationsBloc.add(WordTranslationIsGettingReadyEvent(
    // //   vocabularyId: widget.vocabulary_id, 
    // // vocabularyType: widget.vocabulary_type
    // ));
    BlocProvider.of<WordTranslationBloc>(context).add(WordTranslationIsGettingReadyEvent(
      vocabularyId: widget.vocabulary_id, 
      vocabularyType: widget.vocabulary_type
      ));

  }

  @override
  void dispose() {
    _word_controller.dispose();
    _translation_controller.dispose();
    super.dispose();
  }

/*   Future<List<WordTranslation>> _wordsTranslationsListFuture(
      int vocabularyId, String vocabularyType) {
    return Server.getWordsFromVocabulary(vocabularyId, vocabularyType);
  } */

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заполнение словаря'),
        centerTitle: true,
      ),
      body: SafeArea(
              child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(children: [
                Text(
                    'Впишите минимум ${Config.minAvailableWordsInVocabulary} слов'),
                // if (_wordsTranslationsList.isNotEmpty)
                BlocBuilder<WordTranslationBloc, WordTranslationState>(
                  builder: (context, state) {
                    // print(state);
                    if (state is WordTranslationsIsReady)
                    {
                    _wordsTranslationsList = state.wordTranslationsLoaded;
                    return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _wordsTranslationsList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child:
                                                    Text(_wordsTranslationsList[index].word)),
                                            Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_wordsTranslationsList.length <
                                                          Config.minAvailableWordsInVocabulary +
                                                              1) {
                                                        _submit_button_active = false;
                                                      } else {
                                                        _submit_button_active = true;
                                                      }
                                                      _wordsTranslationsList.removeAt(index);
                                                    });
                                                  },
                                                ))
                                          ],
                                        ),
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _wordsTranslationsList[index]
                                                .translationList
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, int subIndex) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(_wordsTranslationsList[index]
                                                        .translationList[subIndex]),
                                                  ))
                                                ],
                                              );
                                            })
                                      ],
                                    );
                                  });
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
      
                Form(
                  key: _formKey_for_word,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: TextFormField(
                    controller: _word_controller,
                    decoration: const InputDecoration(label: Text('Введите слово')),
                    validator: (text) {
                      if (Validator.checkIsTextIsEmpty(text)) {
                        return 'Поле не должно быть пустым';
                      } else if (Validator.checkTextLength(text!)){
                        return 'Допускается только длина ${Config.maxAvailablTextLength} символов';
                      } else if (widget.vocabulary_type == 'rus_en') {
                        return Validator.checkLanguage(text!, _latinRegExp)
                            ? 'Не допускается латиница'
                            : null;
                      } else if (widget.vocabulary_type == 'en_rus') {
                        return Validator.checkLanguage(text!, _cyrillicRegExp)
                            ? 'Не допускается кириллица'
                            : null;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_currentTranslationListWithDuplicates.isNotEmpty)
                  ListView.builder(
                      itemCount: _currentTranslationListWithDuplicates.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: Text(
                            _currentTranslationListWithDuplicates[index],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        );
                      }),
                Form(
                    key: _formKey_for_translation,
                    child: TextFormField(
                      controller: _translation_controller,
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: const InputDecoration(label: Text('Введите перевод')),
                      validator: (text) {
                        if (Validator.checkIsTextIsEmpty(text)) {
                          return 'Поле не должно быть пустым';
                        } else if (Validator.checkTextLength(text!)){
                        return 'Допускается только длина ${Config.maxAvailablTextLength} символов';
                        } else if (widget.vocabulary_type == 'en_rus') {
                          return Validator.checkLanguage(text!, _latinRegExp)
                              ? 'Латиница не допускается'
                              : null;
                        } else if (widget.vocabulary_type == 'rus_en') {
                          return Validator.checkLanguage(text!, _cyrillicRegExp)
                              ? 'Кириллица не допускается'
                              : null;
                        } else {
                          return null;
                        }
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                if (_currentTranslationList.length <
                    Config.maxAvailableTranslations - 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey_for_translation.currentState!.validate()) {
                            setState(() {  
                              _currentTranslationListWithDuplicates.add(_translation_controller
                                  .text
                                  .trim()
                                  .capitalize());
                              _translation_controller.clear();
                            });
                          }
                        },
                        child: const Text('Добавить перевод')),
                  ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey_for_word.currentState!.validate() &&
                          _formKey_for_translation.currentState!.validate()) {
                        setState(() {
                          if (_wordsTranslationsList.length >=
                              Config.minAvailableWordsInVocabulary - 1) {
                            _submit_button_active = true;
                          }
                          _currentTranslationListWithDuplicates.add(
                              _translation_controller.text.trim().capitalize());
                          _currentTranslationList = _currentTranslationListWithDuplicates.toSet().toList();
                              // Оставляем в списке только допустимое количество переводов
                              Map<String, List<String>> repeatedWords = {};
                              String? currentRepeatedWord = null;
                              _wordsTranslationsList.forEach((elem) {
                                if (elem.word == _word_controller.text.trim().capitalize()){
                                  print(elem.translationList);
                                  currentRepeatedWord = elem.word;
                                  // repeatedWords[elem.word] = elem.translationList;
                                  repeatedWords.putIfAbsent(elem.word, () => []);
                                  repeatedWords[elem.word]!.addAll(elem.translationList);
                                  repeatedWords[elem.word]!.addAll(_currentTranslationList);
                                  print(repeatedWords);
                                  if (repeatedWords[elem.word]!.length > Config.maxAvailableTranslations){
                                    repeatedWords[elem.word]!.removeRange(Config.maxAvailableTranslations,
                                    repeatedWords[elem.word]!.length);
                                    FlushbarView.buildFlushbarWithTitle(context, 
                                    'Допустимо только ${Config.maxAvailableTranslations} переводов');
                                  } else {
                                    FlushbarView.buildFlushbarWithTitle(context,
                                    'Переводы слова ${elem.word} добавлены в список');
                                  } 
                                  elem.translationList = repeatedWords[elem.word]!.toSet().toList();                                  
                                }
                              });
                              if(_word_controller.text.trim().capitalize() != currentRepeatedWord){
                                _wordsTranslationsList.add(WordTranslation(
                              word: _word_controller.text.trim().capitalize(),
                              translationList: List.from(_currentTranslationList),
                              vocabularyType: widget.vocabulary_type));
                              }
                          currentRepeatedWord = null;
                          repeatedWords.clear();
                          _currentTranslationListWithDuplicates.clear();
                          _currentTranslationList.clear();
                          _word_controller.clear();
                          _translation_controller.clear();
                        });
                      }
                    },
                    child: const Text('Сформировать'))
              ]),
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: ElevatedButton(
          onPressed: _submit_button_active
              ? () async {
                  await Server.insertWordsTranslations(widget.vocabulary_id,
                      _wordsTranslationsList, widget.vocabulary_type);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const App()));
                }
              : null,
          child: const Text('Сохранить словарь'),
        ),
      ),
    );
  }
}
