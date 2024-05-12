import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../config/config.dart';
import '../../widgets/drawer.dart';
import '../../functions/api.dart';

class TeacherTariffPage extends StatefulWidget {
  const TeacherTariffPage({super.key});

  @override
  _TeacherTariffPageState createState() => _TeacherTariffPageState();
}

class _TeacherTariffPageState extends State<TeacherTariffPage> {
  User _user = User();
  Config _config = Config();
  bool _isTariffActivating = false;
  bool _isSubmitButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Тариф Учитель'),
      centerTitle: true,
      iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _isTariffActivating ?
              CircularProgressIndicator() :
              SizedBox(
                height: 40,
                child: Text('Баланс: ${_user.getBalance} руб.', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Text('Статус Учителя: ', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    if (_user.getRoleSlug == 'student')
                    Text('Не активен', 
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 , color: Colors.red),)
                    else if (_user.getRoleSlug == 'teacher')
                    Text('Активен', 
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 ,color: Colors.green),)
                  ],
                ),
              ),
              /* Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,),
                ),
              ), */
              SizedBox(height: 10,),
              if (_user.getIsTrialActive == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: () => showDialog<String>(context: context, builder: (BuildContext context) =>
              AlertDialog(
                title: Text('Активиция статуса Учителя'),
                content: Text('Пополните баланс на ${_config.getPrice} руб. любым удобным для Вас способом ' +
                  'и нажмите кнопку "Проверить статус платежа", чтобы изменения баланса вступили в силу. ' +
                  'Перезапустите приложение (закройте и снова откройте), чтобы изменения Профиля вступили в силу.' +
                  'При наличии на балансе ${_config.getPrice} руб. эта сумма автоматически спишется и Ваш статус учителя активируется на месяц. ' +
                  'При окончании месяца на Вашем балансе автоматически спишется ${_config.getPrice} руб. и статус Учителя останется при Вас. Если же суммы не хватит ' +
                  'Ваш статус вернется в роль Ученика, но Ваши данные Учителя сохранятся.',
                  textAlign: TextAlign.center,),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text('Ок'))
                  ],
              )), 
              child: Text('Как активировать статус Учителя?')),
              Center(
                child: ElevatedButton(onPressed: () {},
                child: Text('Пополнить баланс')),
              ),
              Center(
                child: TextButton(onPressed: () async {
                  setState(() {
                    _isTariffActivating = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  if (_user.getRoleSlug != 'teacher')
                  {
                    await Api.activateTeacherRole(_user.getId, false);
                  }
                  _user.getUserDataFromJson(await Api.getJsonUserData(_user.getId));
                  _user.setUserBalance = double.parse(await Api.checkUserBalance(_user.getId));
                  setState(() {
                    _isTariffActivating = false;
                  });
                },
                child: Text('Проверить статус платежа')),
              )
                ],)
                else if(_user.getIsTrialActive == true)
                Column(children: [
                  Text('Вам доступен пробный период на первый месяц:) Платить ничего не нужно.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: _isSubmitButtonPressed ? 
                  null
                  :
                  () async {
                    setState(() {
                      _isSubmitButtonPressed = true;
                    });
                    await Api.activateTeacherRole(_user.getId, true);
                    _user.getUserDataFromJson(await Api.getJsonUserData(_user.getId));
                    showDialog<String>(context: context, builder: (BuildContext context) =>AlertDialog(
                      title: Text('Внимание'),
                      content: Text('Вы получили статус Учителя. Перезапустите приложение (закройте и снова откройте), ' +
                      'чтобы изменения вступили в силу', textAlign: TextAlign.center,),
                      actions: <Widget>[
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, 
                        child: Text('Ок'))
                      ],
                      )
                      );
                      setState(() {
                        _isSubmitButtonPressed = false;
                      });
                  }, child: Text('Стать Учителем'))
                ],)
              
            ]
            ),)
            ),
    );
  }
}