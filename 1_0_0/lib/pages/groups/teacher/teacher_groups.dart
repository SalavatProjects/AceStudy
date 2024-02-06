import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/teacher_groups/teacher_groups_bloc.dart';
import '../../../models/group.dart';
import '../../../functions/api.dart';
import 'create_group_page.dart';
import 'edit_group_page.dart';

class TeacherGroups extends StatefulWidget {
  TeacherGroups({super.key});

  @override
  _TeacherGroupsState createState() => _TeacherGroupsState();
}

class _TeacherGroupsState extends State<TeacherGroups> {

  late TeacherGroupsBloc _teacherGroupsBloc;
  List<Group> _groups = [];
  bool _deleteButtonPressed = false;

  @override
  void initState(){
    super.initState();
    _teacherGroupsBloc = BlocProvider.of<TeacherGroupsBloc>(context);
    _teacherGroupsBloc.add(TeacherGroupsGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    SafeArea(
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
                    TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateGroupPage())
                            );
                  },
                  child: ListTile(
                    tileColor: Colors.grey.shade200,
                    leading: const Icon(Icons.add_circle_outline_sharp),
                    title: Text('Добавить группу'),
                    minLeadingWidth: 10,
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                _groups.isNotEmpty ?
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                          child: _groups[index].getIcon == 'none'
                        ? const Icon(Icons.group)
                        : const Icon(Icons.ac_unit),),
                        title: Text(_groups[index].getName),
                        subtitle: Text('Создана ${_groups[index].getCreatedAt}'),
                        minLeadingWidth: 10,
                        trailing: 
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () {
                              // _teacherGroupsBloc.add(TeacherGroupsGettingReadyEvent());
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (BuildContext context) => EditGroupPage(group: _groups[index],)));
                            }, 
                            icon: Icon(Icons.create_rounded)),
                            IconButton(onPressed: () => showDialog<String>(context: context, 
                            builder: (BuildContext context) => 
                              AlertDialog(
                                title: Text('Удаление группы'),
                                content: _deleteButtonPressed
                                ? CircularProgressIndicator()
                                : Text('Вы уверены, что хотите удалить группу ${_groups[index].getName}?'),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, 
                                  child: Text('Отмена')),
                                  TextButton(onPressed: () async {
                                    setState(() {
                                      _deleteButtonPressed = true;
                                    });
                                    await Api.deleteGroup(_groups[index].getId);
                                    _teacherGroupsBloc.add(TeacherGroupsGettingReadyEvent());
                                    Navigator.pop(context);
                                    setState(() {
                                      _deleteButtonPressed = false;
                                    });
                                  }, 
                                  child: Text('Да'))
                                ],
                              )), 
                            icon: const Icon(Icons.delete))
                          ]),
                      ),
                    );
                  })
                :
                Center(
                  child: Text('У Вас ещё нет ни одной группы!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,),
                ) 
                  ]),),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
              );
          }
        }),
      ),
      );
  }
}