import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_vocabulary/voc_bloc.dart';
import '../models/vocabulary.dart';
import '../models/user.dart';
import 'game_page.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({ Key? key }) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  User _user = User();
  int? _expandedItemIndex;
  ScrollController _scrollController = new ScrollController();
  List<Vocabulary>? _vocabularies;

  void initState() {
    super.initState();
    BlocProvider.of<VocPageBloc>(context)
    .add(VocabulariesGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<VocPageBloc, VocPageState>(
          builder: (context, state) {
            if (state is VocabulariesIsReady)
            {
              _vocabularies = state.vocabularies;
              // print(_vocabularies);
              if (_vocabularies!.isNotEmpty)
              {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  child: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: [ExpansionPanelList(
                    expansionCallback: (int panelIndex, bool isExpanded) {
                      setState(() {
                        if (isExpanded)
                        {
                          _expandedItemIndex = panelIndex;
                          _scrollController.animateTo(panelIndex * _scrollController.position.viewportDimension, 
                          duration: Duration(microseconds: 1500), 
                          curve: Curves.easeOut);
                        } else {
                          _expandedItemIndex = null;
                        }
                      });
                    },
                    children: [
                      for (var i = 0; i < _vocabularies!.length; i++)
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                          return ListTile(
                            leading: _vocabularies![i].icon == 'none'
                                        ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: const Icon(Icons.book_outlined),
                                        )
                                        : Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: const Icon(Icons.ac_unit),
                                        ),
                            title: Text(_vocabularies![i].getName),
                            subtitle: Text('Кол-во слов: ${_vocabularies![i].getWordsCount}'),
                          );
                          // Text(_vocabularies![i].getName);
                        }, 
                        body: _vocabularies![i].getWordsCount == 0 ? 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Нет слов в словаре'),
                        )
                        : 
                        Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _vocabularies![i].getWords.length,
                              itemBuilder: (BuildContext context, int wordIndex) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_vocabularies![i].getWords[wordIndex].getName),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _vocabularies![i].getWords[wordIndex].getTranslations.length,
                                      itemBuilder: (BuildContext context, int translateIndex) {
                                        return Padding(padding: EdgeInsets.only(left: 10.0),
                                        child: Text(_vocabularies![i].getWords[wordIndex].getTranslations[translateIndex].getName),);
                                      })
                                  ],
                                );
                              }),
                              ElevatedButton(onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => GamePage(
                                  userId: _user.getId,
                                  vocabularyId: _vocabularies![i].getId,
                                  translationsCount: _vocabularies![i].getTranslationsCount,
                                  attemptNumber: _vocabularies![i].getAttemptNumber, 
                                  words: _vocabularies![i].getWords)));
                              }, 
                              child: Text('Тренироваться'))
                          ],
                        ),
                        isExpanded: _expandedItemIndex == i),
                    ],
                  )],
                              ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('У вас еще нет ни одного словаря, давайте создадим!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,),
                );
              }
              
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
    )
    );
  }
}