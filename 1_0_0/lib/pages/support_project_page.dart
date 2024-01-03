import 'package:flutter/material.dart';

class SupportProjectPage extends StatelessWidget {
SupportProjectPage({super.key});
TextEditingController _wishController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Поддержка проекта'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Text('  Привет! Мы рады приветствовать тебя и благодарим за интерес к нашему проекту. Мы убеждены, что с твоей поддержкой нам удастся достичь наших целей и воплотить наши идеи в жизнь.'),
                Text('  Наш проект посвящен изучению слов английского языка. Мы верим, что это идея, которая может принести реальные изменения и сделать нашу жизнь или жизнь людей вокруг нас лучше. Мы стремимся облегчить запоминание новых слов и вкладываем все свои усилия в это дело.'),
                Text('  Еще раз, спасибо за твою заинтересованность и желание поддержать нас. Вместе мы можем создать что-то удивительное!'),
                SizedBox(height: 10,),
                TextField(
                  controller: _wishController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Пожелания'
                  ),
                ),
                SizedBox(height: 10,),
                Text('Донат в руб.'),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: () {}, 
                    child: Text('50')),
                    ElevatedButton(onPressed: () {}, 
                    child: Text('100')),
                    ElevatedButton(onPressed: () {}, 
                    child: Text('150')),
                    ElevatedButton(onPressed: () {}, 
                    child: Text('500')),
                    ElevatedButton(onPressed: () {}, 
                    child: Text('1000')),
                  ],
                ),
                TextButton(onPressed: () {},
                child: Text('Проверить статус платежа'))
              ],
              ),
          ),
        )
          ),
    );
  }
}