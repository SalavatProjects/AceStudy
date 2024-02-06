import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/vocabulary.dart';
import '../../../blocs/user_vocabulary/voc_bloc.dart';
import '../../../blocs/group_vocabularies/group_vocabularies_bloc.dart';

class AddVocabulary extends StatefulWidget {
  List<Vocabulary> vocabularies;
  AddVocabulary({super.key,
  required this.vocabularies});

  @override
  _AddVocabularyState createState() => _AddVocabularyState();
}

class _AddVocabularyState extends State<AddVocabulary> {
  List<Vocabulary> _vocabularies = [];
  List<Vocabulary> _userVocabularies = [];
  late VocPageBloc _vocPageBloc;
  late GroupVocabulariesBloc _groupVocabulariesBloc;

  void initState(){
    super.initState();
    _vocPageBloc = BlocProvider.of<VocPageBloc>(context);
    _vocPageBloc.add(VocabulariesGettingReadyEvent());
    _vocabularies = List.from(widget.vocabularies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление словаря'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(
        child: BlocBuilder<VocPageBloc, VocPageState>(
          builder: (context, state) {
            if (state is VocabulariesIsReady){
              _userVocabularies = state.vocabularies;
              if (_userVocabularies.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _userVocabularies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          tileColor: Colors.grey.shade200,
                          leading: _userVocabularies[index].icon == 'none'
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: const Icon(Icons.book_outlined),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: const Icon(Icons.ac_unit),
                          ),
                          title: Text(_userVocabularies[index].getName),
                          subtitle: Text('Кол-во слов: ${_userVocabularies[index].getWordsCount}'),
                          trailing: Icon(Icons.add_circle_outline),
                          onTap: () {
                            if (!_vocabularies.any((vocabulary) => vocabulary.getId == _userVocabularies[index].getId)){
                              _vocabularies.add(_userVocabularies[index]);
                              _groupVocabulariesBloc = BlocProvider.of<GroupVocabulariesBloc>(context);
                              _groupVocabulariesBloc.add(GroupVocabulariesGettingReadyEvent(vocabularies: _vocabularies));
                            }
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                    ),
                    );
              } else {
                return Center(
                  child: Text('У вас нет ни одного словаря'),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),);
            }
          },
        )),
    );
  }
}