import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user_statistics/user_statistics_bloc.dart';
import '../../../widgets/user_statistic.dart';
import '../student/student_groups_for_statistic.dart';

class TeacherStatisticsPage extends StatefulWidget {
  const TeacherStatisticsPage({super.key});

  @override
  _TeacherStatisticsPageState createState() => _TeacherStatisticsPageState();
}

class _TeacherStatisticsPageState extends State<TeacherStatisticsPage> {

  late UserStatisticsBloc _userStatisticsBloc;
  late List<Map<String, dynamic>> _statistics;
  
  @override
  void initState() {
    super.initState();
    _userStatisticsBloc = BlocProvider.of<UserStatisticsBloc>(context);
    _userStatisticsBloc.add(UserStatisticsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Личная статистика'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),
      ),
      body: SafeArea(
        child: BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
          builder: (context, state) {
            if (state is UserStatisticsIsReady)
            {
              _statistics = state.statistics;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: 
                          (BuildContext context) => StudentGroupsForStatistic()));
                        },
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                        ),
                        child: Text('Статистика, где я участник группы')),
                      ),
                    ),
                    _statistics.isNotEmpty ?
                UserStatistic(userStatisticsBloc: _userStatisticsBloc, statistics: _statistics)
                :
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Text('В данный момент статистика пуста. Пройдите тренировки, для её заполнения',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,),
                ),
                  ],)
                 
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },),),
    );
  }
}