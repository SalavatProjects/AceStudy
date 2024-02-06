import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/teacher_groups/teacher_groups_bloc.dart';
import '../../../models/group.dart';
import 'group_vocabularies.dart';
import 'teacher_statistics_page.dart';

class StudentsGroupsStatistics extends StatefulWidget {
  StudentsGroupsStatistics({super.key});

  @override
  _StudentsGroupsStatisticsState createState() => _StudentsGroupsStatisticsState();
}

class _StudentsGroupsStatisticsState extends State<StudentsGroupsStatistics> {
  late TeacherGroupsBloc _teacherGroupsBloc;
  List<Group> _groups = [];

  @override
  void initState(){
    super.initState();
    _teacherGroupsBloc = BlocProvider.of<TeacherGroupsBloc>(context);
    _teacherGroupsBloc.add(TeacherGroupsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TeacherGroupsBloc, TeacherGroupsState>(
          builder: (context, state) {
            if (state is TeacherGroupsIsReady)
            {
              _groups = state.groups;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) => TeacherStatisticsPage()));
                        }, 
                        child: Text('Личная статистика')),
                      ),
                      Divider(thickness: 1,),
                  _groups.isNotEmpty ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _groups.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        tileColor: Colors.grey.shade100,
                        visualDensity: VisualDensity(vertical: 3),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle
                          ),
                          child: _groups[index].getIcon == 'none'
                          ? const Icon(Icons.group)
                          : const Icon(Icons.ac_unit),),
                          title: Text(_groups[index].getName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                          // subtitle: Text('Создана ${_groups[index].getCreatedAt}'),
                          minLeadingWidth: 10,
                          onTap: () {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (BuildContext context) => GroupVocabularies(
                              groupId: _groups[index].getId, vocabularies: _groups[index].getVocabularies)));
                          },
                      );
                    })
                  :
                  Center(
                    child: Text('У Вас ещё нет ни одной группы!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,),
                  ),
                  ],),   
              ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },),),
    );
  }
}