import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';
import '../../config/config.dart';
import '../../widgets/flushbar.dart';
import '../../functions/authorization.dart';
import '../../functions/launch_url.dart';
import '../../app.dart';
import 'profile_edit.dart';
import 'support_project_page.dart';
import 'teacher_tariff_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  bool _dataLoaded = false;
  User _user = User();
  Config _config = Config();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle,
                  size: 50,),
                title: Text('${_user.getName} ${_user.getSurname}'),
                subtitle: Text('${_user.getRole}'),
                trailing: IconButton(icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => ProfileEdit())
                  );
                },),
              ),
              Divider(thickness: 1,),
              if (_user.getRoleSlug == 'teacher')
              Column(
                children: <Widget>[
                Align(
                alignment: Alignment.centerLeft,
                child: Text('Баланс: ${_user.getBalance} руб.', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                  ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Статус активен до ${_user.getTeacherStatusEndDate}',
                  style: TextStyle(fontSize: 18),),
                ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Логин: ${_user.getLogin}',style: TextStyle(fontSize: 18,
                  color: Colors.indigo.shade900),),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _user.getLogin)).then((value) => //only if ->
                      FlushbarView.buildFlushbarWithTitle(context, 'Логин скопирован!')); // -> show a notification      
                    }, 
                    icon: Icon(Icons.content_copy,
                    color: Colors.purple.shade800,)),
                    
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Создано словарей: ${_user.getVocabulariesCreated}',
                style: TextStyle(fontSize: 18),)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Словарей изучено: ${_user.getVocabulariesLearned}',
                style: TextStyle(fontSize: 18),)
                ),
                SizedBox(height: 10,),
                if (_user.getRoleSlug == 'student')
                Align(
                  alignment: Alignment.centerLeft,
                  child: 
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => TeacherTariffPage()));
                  }, 
                  child: Text('Стать учителем')),
                )
                else if (_user.getRoleSlug == 'teacher')
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => TeacherTariffPage()));
                    },
                    child: Text('Пополнить баланс')),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () async {
                      await launch_url(Uri.parse(_config.getTechnicalSupport));
                    },
                    child: Text('Тех. поддержка')),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(onPressed: () async {
                    await launch_url(Uri.parse(_config.getTelegramGroup));
                  },
                  icon: Icon(Icons.telegram),),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: ((context) => SupportProjectPage()))
                      );
                    },
                    child: Text('Поддержать проект')),
                ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(onPressed: () async {
                        await Authorization.logout();
                        Navigator.push(context, 
                        MaterialPageRoute(builder: ((context) => App()))
                        );
                      }, 
                      child: Text('Выйти')),
                  ),  
            ]),
        ),
          )
          ),
    );
  }
}