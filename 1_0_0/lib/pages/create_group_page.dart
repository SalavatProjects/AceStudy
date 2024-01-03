import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/config.dart';
import '../utils/validators.dart';
import '../functions/api.dart';
import '../functions/modify.dart';
import '../models/user.dart';
import '../blocs/teacher_groups/teacher_groups_bloc.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _groupController = TextEditingController();
  bool _submitButtonPressed = false;
  User _user = User();
  Config _config = Config();

  @override
  void dispose() {
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание группы'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _groupController,
                  decoration: InputDecoration(
                    labelText: 'Группа',
                    hintText: 'Введите название группы' 
                  ),
                  validator: (text) {
                    if (Validator.checkIsTextIsEmpty(text)){
                      return 'Поле не должно быть пустым';
                    }
                    if (Validator.checkTextLength(text!)){
                      return 'Допускается длина только ${_config.getMaxAvailablTextLength} символов';
                    }
                    return null;
                  },
                ))
            ]),)),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: ElevatedButton(onPressed: _submitButtonPressed ?
              null 
              :
              () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _submitButtonPressed = true;
                  });
                  await Api.createGroup(_user.getId, 
                  _groupController.text.trim().capitalize(),
                  'none');
                  BlocProvider.of<TeacherGroupsBloc>(context).add(TeacherGroupsGettingReadyEvent());
                  Navigator.pop(context);
                }
              },
              child: Text('Создать группу'),),),
    );
  }
}