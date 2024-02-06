import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/vocabulary.dart';
import '../../../models/user_mistake_statistics.dart';
import '../../../models/group_member.dart';
import '../../../functions/api.dart';
import '../../../blocs/student_statistics_by_vocabulary/students_statistics_by_vocabulary_bloc.dart';
import '../../../widgets/statistic_table.dart';

class StudentStatisticsByVocabulary extends StatefulWidget {
  int groupId;
  Vocabulary vocabulary;
  StudentStatisticsByVocabulary({
    super.key,
    required this.groupId,
    required this.vocabulary
  });

  @override
  _StudentStatisticsByVocabularyState createState() => _StudentStatisticsByVocabularyState();
}

class _StudentStatisticsByVocabularyState extends State<StudentStatisticsByVocabulary> {

  late StudentsStatisticsByVocabularyBloc _studentsStatisticsByVocabularyBloc;
  Map _statistitics = {};
  late GroupMember _student;
  late UserMistakeStatistics _studentMistakeStatistics;
  late int _totalScore;
  late int _totalPercent;
  bool _deleteButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _studentsStatisticsByVocabularyBloc = BlocProvider.of<StudentsStatisticsByVocabularyBloc>(context);
    _studentsStatisticsByVocabularyBloc.add(StudentsStatisticsByVocabularyGettingReadyEvent(
      groupId: widget.groupId, vocabulary: widget.vocabulary));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Статистика студентов'),
      centerTitle: true,
      iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(
        child: BlocBuilder<StudentsStatisticsByVocabularyBloc, StudentsStatisticsByVocabularyState>(
          builder: (context, state) {
            if (state is StudentsStatisticsByVocabularyIsReady)
            {
              _statistitics = state.statistics;
              // print(_statistitics['students']);
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Словарь: ${widget.vocabulary.getName}', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                      Divider(thickness: 1,),
                      if (_statistitics['students'].isNotEmpty)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _statistitics['students'].length,
                        itemBuilder: (BuildContext context, int studentIndex) {
                          // _student = _statistitics['students'][studentIndex]['student'];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_statistitics['students'][studentIndex]['student'].getName} ${_statistitics['students'][studentIndex]['student'].getSurname}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                              Text(_statistitics['students'][studentIndex]['student'].getLogin,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _statistitics['students'][studentIndex]['attempts'].length,
                                itemBuilder: (BuildContext context, int attemptIndex) {
                                  _studentMistakeStatistics = _statistitics['students'][studentIndex]['attempts'][attemptIndex];
                                  _totalScore = widget.vocabulary.getTranslationsCount - _studentMistakeStatistics.getMistakesCount;
                                  _totalPercent = ((_totalScore/widget.vocabulary.getTranslationsCount) * 100).round();
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('Номер попытки: ${_studentMistakeStatistics.getAttemptNumber}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade700),),
                                      ),
                                      Text('Пройдено на ${_totalPercent} процентов',
                                      style: TextStyle(fontSize: 18),),
                                      SizedBox(height: 4,),
                                      _studentMistakeStatistics.getWords == null
                                      ? Center(
                                        child: Text('Студент не ошибся ни в одном слове',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),),
                                      )
                                      : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text('Студент ошибся в следующих словах',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),)),
                                            Center(
                                              child: StatisticTable(words: _studentMistakeStatistics.getWords!,)
                                            )

                                        ],
                                      ),
                                    ],
                                  );
                                }),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text('Удаление статистики студента'),
                                          content: _deleteButtonPressed
                                          ? CircularProgressIndicator()
                                          : Text('Вы уверены, что хотите очистить статистику студента ${_statistitics['students'][studentIndex]['student'].getName} ${_statistitics['students'][studentIndex]['student'].getSurname}\nпо словарю ${widget.vocabulary.getName}?',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,),
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
                                              await Api.clearStudentStatistics(_statistitics['students'][studentIndex]['student'].getId, widget.vocabulary.getId, widget.groupId);
                                              _studentsStatisticsByVocabularyBloc.add(StudentsStatisticsByVocabularyGettingReadyEvent(
                                              groupId: widget.groupId, vocabulary: widget.vocabulary));
                                              Navigator.pop(context);
                                              setState(() {
                                                _deleteButtonPressed = false;
                                              });
                                            }, 
                                            child: Text('Да'))
                                          ],
                                        )
                                      ),
                                      child: Text('Очистить статистику студента'),
                                      ),
                                      ),
                                Divider(thickness: 1,),
                            ],
                          );
                        })
                        else
                        Center(
                          child: Text('В данный момент по этому словарю нет статистики!',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                          textAlign: TextAlign.center,),
                        )
                    ],),
                ),
                );
            } else {
              return Center(
                child: CircularProgressIndicator(),);
            }
          },),),
    );
  }
}