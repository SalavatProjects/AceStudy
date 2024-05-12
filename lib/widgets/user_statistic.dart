import 'package:flutter/material.dart';

import '../../functions/api.dart';
import '../../blocs/user_statistics/user_statistics_bloc.dart';
import 'statistic_table.dart';

class UserStatistic extends StatefulWidget {

  UserStatisticsBloc userStatisticsBloc;
  List<Map<String, dynamic>> statistics;

  UserStatistic({super.key,
  required this.userStatisticsBloc,
  required this.statistics});

  @override
  _UserStatisticState createState() => _UserStatisticState();
}

class _UserStatisticState extends State<UserStatistic> {

  bool _deleteButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      child: Column(children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.statistics.length,
          itemBuilder: (BuildContext context, int statistic_index){
            int vocabularyId = widget.statistics[statistic_index]['vocabulary'].getId;
            int userId = (widget.statistics[statistic_index]['user_id']);
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                    leading: Icon(Icons.book_outlined),
                    title: Text('Словарь: ${widget.statistics[statistic_index]['vocabulary'].getName}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade800),),
                    subtitle: Text('Тренировался ${widget.statistics[statistic_index]['vocabulary'].getUsersAttemptNumber[userId.toString()]} раз'),
                    ),
                    Divider(thickness: 1,),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.statistics[statistic_index]['mistake_statistics'].length,
                      itemBuilder: (BuildContext context, int attempt_index) {
                        int translationsCount = widget.statistics[statistic_index]['vocabulary'].getTranslationsCount;
                        int errorTranslationsCount = widget.statistics[statistic_index]['mistake_statistics'][attempt_index].getMistakesCount;
                        int totalScore = translationsCount - errorTranslationsCount;
                        int totalPercent = ((totalScore/translationsCount) * 100).round();
                        // print('translationsCount: $translationsCount');
                        // print('errorTranslationsCount: $errorTranslationsCount');
                        // print('totalScore: $totalScore');
                        // print('totalPercent: $totalPercent\n');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 12,),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Номер попытки ${widget.statistics[statistic_index]['mistake_statistics'][attempt_index].getAttemptNumber}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade700),)
                                ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Пройдено на $totalPercent процентов',
                              style: TextStyle(fontSize: 16),),),),
                              widget.statistics[statistic_index]['mistake_statistics'][attempt_index].getWords == null ?
                              Align(
                                alignment: Alignment.center,
                                child: Text('Вы не ошиблись ни в одном слове',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.green),))
                              :
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('Вы ошиблись в следующих словах',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red),)
                                      ),
                                  ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: StatisticTable(words: widget.statistics[statistic_index]['mistake_statistics'][attempt_index].getWords!,),
                                            )
                                ],)
                          ],
                        );
                      }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: () => showDialog<String>(
                          context: context, 
                          builder: (BuildContext context) => 
                            AlertDialog(
                              title: Text('Удаление статистики словаря'),
                              content: _deleteButtonPressed 
                              ? CircularProgressIndicator()
                              : Text('Вы уверены, что хотите очистить статистику словаря ${widget.statistics[statistic_index]['vocabulary'].getName}?'),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                child: Text('Отмена')),
                                TextButton(onPressed: _deleteButtonPressed ? 
                                null : 
                                () async {
                                  setState(() {
                                    _deleteButtonPressed = true;
                                  });
                                  await Api.clearVocabularyStatistics(userId, widget.statistics[statistic_index]['vocabulary'].getId);
                                  widget.userStatisticsBloc.add(UserStatisticsGettingReadyEvent());
                                  Navigator.pop(context);
                                  setState(() {
                                    _deleteButtonPressed = false;
                                  });
                                }, 
                                child: Text('Да'))
                              ],
                            )),
                        child: Text('Очистить статистику')),
                      )
                  ],
                ),
              ),
            );
          })
      ]),
    );
  }
}