import 'package:flutter/material.dart';

import '../../../models/vocabulary.dart';
import '../../../models/user.dart';
import '../../../widgets/train.dart';

class GroupTrains extends StatefulWidget {
  List<Vocabulary> vocabularies;
  int groupId;
  GroupTrains({super.key,
  required this.vocabularies,
  required this.groupId});

  @override
  _GroupTrainsState createState() => _GroupTrainsState();
}

class _GroupTrainsState extends State<GroupTrains> {

  User _user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренировка'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: widget.vocabularies.isNotEmpty 
          ? Train(
            vocabularies: widget.vocabularies, 
          userId: _user.getId,
          groupId: widget.groupId,)
          : Text('В группе нет словарей', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),)
          ,),),
    );
  }
}