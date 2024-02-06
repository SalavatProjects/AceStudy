import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../pages/train/game_page.dart';

class Train extends StatefulWidget {
  List<Vocabulary> vocabularies;
  int userId;
  int? groupId;
  Train({super.key,
  required this.vocabularies,
  required this.userId,
  required this.groupId});

  @override
  _TrainState createState() => _TrainState();
}

class _TrainState extends State<Train> {

  int? _expandedItemIndex;
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                      for (var i = 0; i < widget.vocabularies.length; i++)
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                          return ListTile(
                            leading: widget.vocabularies[i].icon == 'none'
                                        ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: const Icon(Icons.book_outlined),
                                        )
                                        : Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: const Icon(Icons.ac_unit),
                                        ),
                            title: Text(widget.vocabularies[i].getName),
                            subtitle: Text('${widget.vocabularies[i].getType} Кол-во слов: ${widget.vocabularies[i].getWordsCount}'),
                          );
                          // Text(_vocabularies![i].getName);
                        }, 
                        body: widget.vocabularies[i].getWordsCount == 0 ? 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Нет слов в словаре'),
                        )
                        : 
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.vocabularies[i].getWords.length,
                                itemBuilder: (BuildContext context, int wordIndex) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.vocabularies[i].getWords[wordIndex].getName,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.indigo.shade900),),
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: widget.vocabularies[i].getWords[wordIndex].getTranslations.length,
                                          itemBuilder: (BuildContext context, int translateIndex) {
                                            return Padding(padding: EdgeInsets.only(left: 10.0),
                                            child: Text(widget.vocabularies[i].getWords[wordIndex].getTranslations[translateIndex].getName,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green.shade800),),);
                                          })
                                      ],
                                    ),
                                  );
                                }),
                            ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ElevatedButton(onPressed: () {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => GamePage(
                                    userId: widget.userId,
                                    vocabularyId: widget.vocabularies[i].getId,
                                    groupId: widget.groupId,
                                    translationsCount: widget.vocabularies[i].getTranslationsCount,
                                    usersAttemptNumber: widget.vocabularies[i].getUsersAttemptNumber, 
                                    words: widget.vocabularies[i].getWords)));
                                }, 
                                child: Text('Тренироваться')),
                              )
                          ],
                        ),
                        isExpanded: _expandedItemIndex == i),
                    ],
                  )],
                              );
  }
}