import 'package:ace_study/blocs/user_vocabulary/voc_bloc.dart';
import 'package:ace_study/models/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_vocabulary/voc_bloc.dart';
import '../models/vocabulary.dart';
import 'game_page.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({ Key? key }) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  int? expandedItemIndex;
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
              if (_vocabularies != null)
              {
                return ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: [ExpansionPanelList(
                  expansionCallback: (int panelIndex, bool isExpanded) {
                    setState(() {
                      if (isExpanded)
                      {
                        expandedItemIndex = panelIndex;
                        _scrollController.animateTo(panelIndex * _scrollController.position.viewportDimension, 
                        duration: Duration(microseconds: 1500), 
                        curve: Curves.easeOut);
                      } else {
                        expandedItemIndex = null;
                      }
                    });
                  },
                  children: [
                    for (var i = 0; i < _vocabularies!.length; i++)
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                        return Text(_vocabularies![i].getName);
                      }, 
                      body: _vocabularies![i].getWordsCount == 0 ? 
                      Text('Нет слов в словаре')
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
                                userId: 1,
                                vocabularyId: _vocabularies![i].getId,
                                translationsCount: _vocabularies![i].getTranslationsCOunt,
                                attemptNumber: _vocabularies![i].getAttemptNumber, 
                                words: _vocabularies![i].getWords)));
                            }, 
                            child: Text('Тренироваться'))
                        ],
                      ),
                      isExpanded: expandedItemIndex == i),
                  ],
                )],
              );
              } else {
                return Text('У вас еще нет ни одного словаря, давайте создадим!');
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