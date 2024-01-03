import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/student_groups/student_groups_bloc.dart';

class StudentGroups extends StatefulWidget {
  const StudentGroups({super.key});

  @override
  _StudentGroupsState createState() => _StudentGroupsState();
}

class _StudentGroupsState extends State<StudentGroups> {

  late StudentGroupsBloc _studentGroupsBloc;

  void initState(){
    super.initState();
    _studentGroupsBloc = BlocProvider.of<StudentGroupsBloc>(context);
    _studentGroupsBloc.add(StudentGroupsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: BlocBuilder<StudentGroupsBloc, StudentGroupsState>(builder: (context, state) {
          if (state is StudentGroupsIsReady)
          {
            return Text('Студент группы');
          } else {
            return Center(
              child: CircularProgressIndicator(),);
          }
        },),)),
    );
  }
}