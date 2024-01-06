import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_statistics/user_statistics_bloc.dart';
import '../functions/api.dart';

class UserStatisticsPage extends StatefulWidget {
  const UserStatisticsPage({super.key});

  @override
  _UserStatisticsPageState createState() => _UserStatisticsPageState();
}

class _UserStatisticsPageState extends State<UserStatisticsPage> {

  late UserStatisticsBloc _userStatisticsBloc;
  late List<Map<String, dynamic>> _statistics;
  bool _deleteButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _userStatisticsBloc = BlocProvider.of<UserStatisticsBloc>(context);
    _userStatisticsBloc.add(UserStatisticsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
          builder: (context, state) {
            if (state is UserStatisticsIsReady)
            {
              _statistics = state.statistics;
              // print(_statistics);
              if (_statistics.isEmpty)
              {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('В данный момент статистика пуста. Пройдите тренировки, для её заполнения',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,),
                );
              } else {        
              return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _statistics.length,
                        itemBuilder: (BuildContext context, int statistic_index){
                          int vocabularyId = _statistics[statistic_index]['vocabulary'].getId;
                          int userId = (_statistics[statistic_index]['user_id']);
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                  leading: Icon(Icons.book_outlined),
                                  title: Text('Словарь: ${_statistics[statistic_index]['vocabulary'].getName}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade800),),
                                  subtitle: Text('Тренировался ${_statistics[statistic_index]['vocabulary'].getUsersAttemptNumber[userId]} раз'),
                                  ),
                                  Divider(thickness: 1,),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _statistics[statistic_index]['mistake_statistics'].length,
                                    itemBuilder: (BuildContext context, int attempt_index) {
                                      int translationsCount = _statistics[statistic_index]['vocabulary'].getTranslationsCount;
                                      int errorTranslationsCount = _statistics[statistic_index]['mistake_statistics'][attempt_index].getMistakesCount;
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
                                              child: Text('Номер попытки ${_statistics[statistic_index]['mistake_statistics'][attempt_index].getAttemptNumber}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade700),)
                                              ),
                                          ),
                                          Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Пройдено на $totalPercent процентов',
                                            style: TextStyle(fontSize: 16),),),),
                                            _statistics[statistic_index]['mistake_statistics'][attempt_index].getWords == null ?
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text('Вы не ошиблись ни в одном слове',
                                              style: TextStyle(fontSize: 16),))
                                            :
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12.0),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text('Вы ошиблись в следующих словах',
                                                    style: TextStyle(fontSize: 16),)
                                                    ),
                                                ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      width: 360,
                                                      child: Table(
                                                        children: [
                                                          TableRow(
                                                            decoration: BoxDecoration(
                                                              color: Colors.blueGrey.shade500,
                                                              borderRadius: BorderRadius.circular(5)),
                                                              children: [
                                                                TableCell(child: Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('Слово',
                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                                                  ),
                                                                )),
                                                                TableCell(child: Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('Переводы',
                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                                                  ),
                                                                )),
                                                              ]
                                                          ),
                                                          ...(List.generate(_statistics[statistic_index]['mistake_statistics'][attempt_index].getWords.length, (word_index) => TableRow(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(width: 2, color: Colors.white),
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.blueGrey.shade200),
                                                              children: [
                                                                TableCell(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: Text(_statistics[statistic_index]['mistake_statistics'][attempt_index].getWords[word_index].getName,
                                                                    style: TextStyle(fontSize: 16),),
                                                                  )),
                                                                TableCell(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: List.generate(_statistics[statistic_index]['mistake_statistics'][attempt_index].getWords[word_index].getTranslations.length, 
                                                                      (translate_index) => Text(_statistics[statistic_index]['mistake_statistics'][attempt_index].getWords[word_index].getTranslations[translate_index].getName,
                                                                      style: TextStyle(fontSize: 16), 
                                                                      )),
                                                                      ),
                                                                  ))
                                                              ]
                                                          )))
                                                          ]),
                                                          ),
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
                                            : Text('Вы уверены, что хотите очистить статистику словаря ${_statistics[statistic_index]['vocabulary'].getName}?'),
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
                                                await Api.clearVocabularyStatistics(userId, vocabularyId);
                                                _userStatisticsBloc.add(UserStatisticsGettingReadyEvent());
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
                  ),
                  );
              }
                } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            
          },
        )
          ),
    );
  }
}