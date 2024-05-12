import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/student_groups/student_groups_bloc.dart';
import '../../../models/group.dart';
import '../student/group_trains.dart';

class TeacherGroupsAsMember extends StatefulWidget {
  const TeacherGroupsAsMember({super.key});

  @override
  _TeacherGroupsAsMemberState createState() => _TeacherGroupsAsMemberState();
}

class _TeacherGroupsAsMemberState extends State<TeacherGroupsAsMember> {
  
  late StudentGroupsBloc _studentGroupsBloc;
  List<Group> _groups = [];

  void initState(){
    super.initState();
    _studentGroupsBloc = BlocProvider.of<StudentGroupsBloc>(context);
    _studentGroupsBloc.add(StudentGroupsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Группы, где я участник'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: BlocBuilder<StudentGroupsBloc, StudentGroupsState>(builder: (context, state) {
          if (state is StudentGroupsIsReady)
          {
            _groups = state.groups;
            if (_groups.isNotEmpty){
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groups.length,
                  itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    tileColor: Colors.grey.shade100,
                    visualDensity: VisualDensity(vertical: 3),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle),
                          child: _groups[index].getIcon == 'none' 
                          ? const Icon(Icons.group)
                          : const Icon(Icons.ac_unit),
                          ),
                    ),
                        title: Text(_groups[index].getName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                        minLeadingWidth: 10,
                        onTap: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (BuildContext context) => GroupTrains(
                            vocabularies: _groups[index].getVocabularies,
                            groupId: _groups[index].getId,)));
                        },
                  ),);
                }),
              );
            } else {
              return Text('Вы не состоите ни в одной группе, обратитесть к Вашему Учителю, чтобы он добавил Вас в группу',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade500), 
              textAlign: TextAlign.center);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),);
          }
        },),)),
    );
  }
}