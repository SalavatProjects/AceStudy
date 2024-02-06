import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_statistics/user_statistics_bloc.dart';
import '../../widgets/user_statistic.dart';
import 'student/student_groups_for_statistic.dart';

class UserStatisticsPage extends StatefulWidget {
  const UserStatisticsPage({super.key});

  @override
  _UserStatisticsPageState createState() => _UserStatisticsPageState();
}

class _UserStatisticsPageState extends State<UserStatisticsPage> {

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
      body: SafeArea(
        child: BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
          builder: (context, state) {
            if (state is UserStatisticsIsReady)
            {
              _statistics = state.statistics;
              // print(_statistics);
              // print(_statistics[0]['vocabulary'].getUsersAttemptNumber[6]);       
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(onPressed: () {
                           Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) => StudentGroupsForStatistic())
                            );             
                        }, 
                        child: Text('Статистика по группам')),
                      ),
                    ),
                    if (_statistics.isNotEmpty)
                    UserStatistic(userStatisticsBloc: _userStatisticsBloc, statistics: _statistics)
                    else
                    Text('В данный момент статистика пуста. Пройдите тренировки, для её заполнения',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,),
                  ],
                ),
              );
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