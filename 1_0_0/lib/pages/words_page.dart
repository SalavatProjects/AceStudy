import 'package:ace_study/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/validators.dart';
import '../functions/api.dart';
import '../app.dart';
import '../widgets/flushbar.dart';
import '../functions/modify.dart';

class WordsView extends StatefulWidget {
  int vocabularyId;
  String vocabularyType;
  Map<String, List<String>> wordsTranslations;
  WordsView({
      super.key, 
      required this.vocabularyId, 
      required this.vocabularyType,
      required this.wordsTranslations,
      });

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
  List<String> _words = [];
  Map<String, List<String>> _wordsTransaltionsMap = {};
  Map<String, List<String>> testMap = {};

  @override
  void initState() {
    super.initState();
    _wordsTransaltionsMap = Map.from(widget.wordsTranslations);
    _words = _wordsTransaltionsMap.keys.toList();
  }

  @override
  void dispose() {
    _word_controller.dispose();
    _translation_controller.dispose();
    super.dispose();
  }

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
                    'Впишите минимум ${Config.getMinAvailableWordsInVocabulary} слов'),
                // if (_wordsTranslationsList.isNotEmpty)
                    ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _words.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child:
                                                    Text(_words[index])),
                                            Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_words.length <
                                                          Config.getMinAvailableWordsInVocabulary +
                                                              1 && _words.length <= Config.getMaxAvailableWordsInVocabulary) {
                                                        _submit_button_active = false;
                                                      } else {
                                                        _submit_button_active = true;
                                                      }
                                                      _wordsTransaltionsMap.remove(_words[index]);
                                                      _words.removeAt(index);
                                                      
                                                    });
                                                  },
                                                ))
                                          ],
                                        ),
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _wordsTransaltionsMap[_words[index]]!.length,
                                            itemBuilder:
                                                (BuildContext context, int subIndex) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(_wordsTransaltionsMap[_words[index]]![subIndex]),
                                                  ))
                                                ],
                                              );
                                            })
                                      ],
                                    );
                                  }),
                    
      
                Form(
                  key: _formKey_for_word,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: TextFormField(
                    controller: _word_controller,
                    decoration: const InputDecoration(label: Text('Введите слово')),
                    validator: (text) {
                      if (Validator.checkIsTextIsEmpty(text)) {
                        return 'Поле не должно быть пустым';
                      } 
                      if (Validator.checkTextLength(text!)){
                        return 'Допускается только длина ${Config.getMaxAvailablTextLength} символов';
                      }
                      if (widget.vocabularyType == 'rus_en') {
                        return Validator.checkLanguage(text, _latinRegExp)
                            ? 'Не допускается латиница'
                            : null;
                      }
                      if (widget.vocabularyType == 'en_rus') {
                        return Validator.checkLanguage(text, _cyrillicRegExp)
                            ? 'Не допускается кириллица'
                            : null;
                      }
                      return null;
                      
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
                          trailing: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                _currentTranslationListWithDuplicates.removeAt(index);
                              });
                            },),
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
                        } else if (Validator.checkTranslateLength(text!)){
                        return 'Допускается только длина ${Config.getMaxAvailableTranslateTextLength} символов';
                        } else if (widget.vocabularyType == 'en_rus') {
                          return Validator.checkLanguage(text, _latinRegExp)
                              ? 'Латиница не допускается'
                              : null;
                        } else if (widget.vocabularyType == 'rus_en') {
                          return Validator.checkLanguage(text, _cyrillicRegExp)
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
                if (_currentTranslationListWithDuplicates.length <
                    Config.getMaxAvailableTranslations - 1)
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
                          if (_wordsTransaltionsMap.length >=
                              Config.getMinAvailableWordsInVocabulary - 1) {
                            _submit_button_active = true;
                            if (_wordsTransaltionsMap.length > Config.getMaxAvailableWordsInVocabulary) {
                              FlushbarView.buildFlushbarWithTitle(context,
                                    'Допустимо только ${Config.getMaxAvailableWordsInVocabulary} слов в словаре');
                                    _submit_button_active = false;
                            }
                          }
                          if(_currentTranslationListWithDuplicates.isNotEmpty){
                            _currentTranslationList.addAll(_currentTranslationListWithDuplicates.toSet().toList());
                          }                          
                          if (_translation_controller.text.isNotEmpty){
                            _currentTranslationList.add(_translation_controller.text.trim().capitalize());
                          }
                          String currentWord = _word_controller.text.trim().capitalize();
                          if (_words.contains(currentWord)){
                            if (_currentTranslationList.length + _wordsTransaltionsMap[currentWord]!.length <= Config.getMaxAvailableTranslations){
                              _currentTranslationList.forEach((element) { 
                                if (!_wordsTransaltionsMap[currentWord]!.contains(element)){
                                  _wordsTransaltionsMap[currentWord]!.add(element);
                                }
                              });
                              FlushbarView.buildFlushbarWithTitle(context,
                                    'Переводы слова ${currentWord} добавлены в список');
                            } else {
                              FlushbarView.buildFlushbarWithTitle(context, 
                                    'Допустимо только ${Config.getMaxAvailableTranslations} переводов');
                            }
                          } else {
                            setState(() {
                              _words.add(currentWord);
                              _wordsTransaltionsMap[currentWord] = [];
                              _wordsTransaltionsMap[currentWord]!.addAll(_currentTranslationList);
                            });
                          }
                          _currentTranslationListWithDuplicates.clear();
                          _currentTranslationList.clear();
                          _word_controller.clear();
                          _translation_controller.clear();
                        });
                      }
                    },
                    child: const Text('Сформировать')),
              ]),
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: ElevatedButton(
          onPressed: _submit_button_active
              ? () async {
                setState(() {
                  _submit_button_active = false;
                });
                await Api.insertWordsTranslations(widget.vocabularyId, _wordsTransaltionsMap); 
                Navigator.push(
                      context, MaterialPageRoute(builder: (context) => App()));
                }
              : null,
          child: const Text('Сохранить словарь'),
        ),
      ),
    );
  }
}
