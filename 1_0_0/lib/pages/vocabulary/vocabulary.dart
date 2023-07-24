import 'package:ace_study/app.dart';
import 'package:ace_study/pages/vocabulary/vocabularies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ace_study/api.dart';
import 'package:ace_study/config.dart';


// ignore: must_be_immutable
class VocabularyView extends StatefulWidget{

  VocabularyView({
    super.key,});

  @override
  State<VocabularyView> createState() => VocabularyViewState();
}

class VocabularyViewState extends State<VocabularyView> {
final _formKey = GlobalKey<FormState>();
String _vocabularyType = 'en_rus';
late TextEditingController _nameVocabularyController;
  
  @override
  void initState() {
    super.initState();
    _nameVocabularyController = TextEditingController();

  }

  @override
  void dispose() {
    _nameVocabularyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание словаря'),
        centerTitle: true,),
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Column(
          children: [
            ListTile(title: Text('Англ/Рус'),
            leading: Radio<String>(
            groupValue: _vocabularyType,
            value: 'en_rus',
            onChanged: (String? value) {
              setState(() {
                _vocabularyType = value!;
              });
            }),
            ),
            ListTile(title: Text('Рус/Англ'),
          leading: Radio<String>(
            groupValue: _vocabularyType,
            value: 'rus_en',
            onChanged: (String? value) {
              setState(() {
                _vocabularyType = value!;
              });
            }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _nameVocabularyController,
                  decoration: InputDecoration(
                    
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Поле не должно быть пустым";
                      }
                      return null;
                    },
                    
                    ),
              ),
            ),
             Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
             child: Container(
              width: double.infinity,
              height: 320,
              color: Colors.grey[300],
              child: Center(
                child: Text('Иконки для словаря')),
             ),)
          ],
          ),
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await open_connection();
              await connection.query('INSERT INTO test.dictionary (name, icon, type, created_at, updated_at, user_id)'+
              ' VALUES (\'${_nameVocabularyController.text.trim().capitalize()}\', null, \'${_vocabularyType}\', current_timestamp(3), current_timestamp(3), 4)');
              _nameVocabularyController.clear();
              Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
            }
          },
          child: Text('Создать словарь')),
          ),
    );
  }
}