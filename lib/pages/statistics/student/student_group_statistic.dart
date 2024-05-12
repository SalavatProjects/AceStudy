import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import '../../../blocs/student_group_statistic/student_group_statistic_bloc.dart';
import '../../../widgets/statistic_table.dart';

class StudentGroupStatistic extends StatefulWidget {
  int groupId;
  StudentGroupStatistic({
    super.key,
    required this.groupId
  });

  @override
  _StudentGroupStatisticState createState() => _StudentGroupStatisticState();
}

class _StudentGroupStatisticState extends State<StudentGroupStatistic> {

  late StudentGroupStatisticBloc _studentGroupStatisticBloc;
  User _user = User();
  late List<Map<String, dynamic>> _statistics;

  void initState(){
    super.initState();
    _studentGroupStatisticBloc = BlocProvider.of<StudentGroupStatisticBloc>(context);
    _studentGroupStatisticBloc.add(StudentGroupStatisticGettingReadyEvent(
      userId: _user.getId, groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика по группам'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),
      ),
      body: SafeArea(child: BlocBuilder<StudentGroupStatisticBloc, StudentGroupStatisticState>(
        builder: (context, state) {
          if (state is StudentGroupStatisticIsReady)
          {
            _statistics = state.statistics;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: _statistics.isNotEmpty ?
                Column(children: <Widget>[
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
                    subtitle: Text('Тренировался ${_statistics[statistic_index]['vocabulary'].getUsersAttemptNumber[userId.toString()]} раз'),
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
                                      child: StatisticTable(words: _statistics[statistic_index]['mistake_statistics'][attempt_index].getWords!,),
                                            )
                                ],)
                          ],
                        );
                      }),
                      
                  ],
                ),
              ),
            );
          })
      ])
                :
                Text('В данный момент статистика по группам пуста.',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },),
        ),
    );
  }
}