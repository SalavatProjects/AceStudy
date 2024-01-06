import 'package:flutter/material.dart';

class StudentsGroupsStatistics extends StatefulWidget {
  StudentsGroupsStatistics({super.key});

  @override
  _StudentsGroupsStatisticsState createState() => _StudentsGroupsStatisticsState();
}

class _StudentsGroupsStatisticsState extends State<StudentsGroupsStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text('Статистика группы студентов'),),),
    );
  }
}