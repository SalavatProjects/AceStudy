import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/settings.dart';
import '../../models/vocabulary.dart';
import '../../models/user.dart';
import '../../blocs/user_vocabulary/voc_bloc.dart';
import '../../functions/api.dart';
import 'vocabulary_page.dart';
import 'words_page.dart';

class VocabulariesView extends StatefulWidget {
  const VocabulariesView({super.key});

  @override
  State<VocabulariesView> createState() => VocabulariesViewState();
}

class VocabulariesViewState extends State<VocabulariesView> {
  List<Vocabulary> _vocabularies = [];
  late VocPageBloc _vocPageBloc;
  bool _deleteButtonPressed = false;
  User _user = User();

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
            if (_vocabularies.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VocabularyView()));
                    },
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
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
                      itemCount: _vocabularies.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: _vocabularies[index].icon == 'none'
                              ? const Icon(Icons.book_outlined)
                              : const Icon(Icons.ac_unit),
                          title: Text(_vocabularies[index].getName),
                          subtitle: Text(
                              '${_vocabularies[index].type} Кол-во слов: ${_vocabularies[index].getWordsCount}'),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                                onPressed: () {
                                  Map<String, List<String>> _wordTranslations =
                                      {};
                                  _vocabularies[index]
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
                                                vocabulary: _vocabularies[index],
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
                                                  'Вы уверены, что хотите удалить словарь ${_vocabularies[index].getName} и все его слова?'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Отмена')),
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _deleteButtonPressed = true;
                                                  });
                                                  await Api.deleteVocabulary(
                                                      _vocabularies[index]
                                                          .getId);
                                                  // print(await Api.getUserVocabulariesCounts(_user.getId));
                                                  _user.setVocabulariesCounts(await Api.getUserVocabulariesCounts(_user.getId));
                                                  _vocPageBloc.add(VocabulariesGettingReadyEvent());
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _deleteButtonPressed = false;
                                                  });
                                                },
                                                child: Text('Да'))
                                          ],
                                        )),
                                icon: const Icon(Icons.delete))
                          ]),
                        );
                      }),
                )
              ]),
            ); } else { 
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
              Text('У вас ещё нет ни одного словаря!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
              textAlign: TextAlign.center,)
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
