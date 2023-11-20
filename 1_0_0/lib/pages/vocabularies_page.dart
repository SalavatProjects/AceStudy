import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/settings.dart';
import '../models/vocabulary.dart';
import '../blocs/user_vocabulary/voc_bloc.dart';
import '../functions/api.dart';
import '../functions/from_json.dart';
import 'vocabulary_page.dart';
import 'words_page.dart';

class VocabulariesView extends StatefulWidget {
  const VocabulariesView({super.key});

  @override
  State<VocabulariesView> createState() => VocabulariesViewState();
}

class VocabulariesViewState extends State<VocabulariesView> {
  List<Vocabulary>? _vocabularies;
  late VocPageBloc _vocPageBloc;
  bool _deleteButtonPressed = false;
  @override
  void initState() {
    super.initState();
    _vocPageBloc = BlocProvider.of<VocPageBloc>(context);
    _vocPageBloc.add(VocabulariesGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<VocPageBloc, VocPageState>(
        builder: (context, state) {
          if (state is VocabulariesIsReady) {
            _vocabularies = state.vocabularies;
            if (_vocabularies != null) {
            return Column(children: [
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VocabularyView()));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.add_circle_outline_sharp),
                    title: Text(
                        settings_language[app_language]!.create_vocabulary),
                    minLeadingWidth: 10,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _vocabularies!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: _vocabularies![index].icon == null
                            ? const Icon(Icons.book_outlined)
                            : const Icon(Icons.ac_unit),
                        title: Text(_vocabularies![index].getName),
                        subtitle: Text(
                            '${_vocabularies![index].type} Кол-во слов: ${_vocabularies![index].getWordsCount}'),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: () {
                                Map<String, List<String>> _wordTranslations =
                                    {};
                                _vocabularies![index]
                                    .getWords
                                    .forEach((element) {
                                  _wordTranslations[element.getName] = [
                                    for (var translation
                                        in element.getTranslations)
                                      translation.getName
                                  ];
                                });
                                //  print(_wordTranslations);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WordsView(
                                              vocabularyId:
                                                  _vocabularies![index].id,
                                              vocabularyType:
                                                  _vocabularies![index]
                                                      .getTypeSlug,
                                              wordsTranslations:
                                                  _wordTranslations,
                                            )));
                              },
                              icon: const Icon(Icons.create_rounded)),
                          IconButton(
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Удаление словаря'),
                                        content: _deleteButtonPressed
                                            ? CircularProgressIndicator()
                                            : Text(
                                                'Вы уверены, что хотите удалить словарь ${_vocabularies![index].getName} и все его слова?'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Отмена')),
                                          TextButton(
                                              onPressed: () async {
                                                await Api.deleteVocabulary(
                                                    _vocabularies![index]
                                                        .getId);
                                                _vocPageBloc.add(VocabulariesGettingReadyEvent());
                                                Navigator.pop(context);
                                              },
                                              child: Text('Да'))
                                        ],
                                      )),
                              icon: const Icon(Icons.delete))
                        ]),
                      );
                    }),
              )
            ]); } else { 
            return Column(
              children: [
                Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VocabularyView()));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.add_circle_outline_sharp),
                    title: Text(
                        settings_language[app_language]!.create_vocabulary),
                    minLeadingWidth: 10,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text('У вас ещё нет ни одного словаря!')
              ],
            ); }
          } else {
            return const CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
