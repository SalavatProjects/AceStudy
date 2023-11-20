import 'package:ace_study/app.dart';
import 'package:ace_study/functions/modify.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';
import '../utils/validators.dart';
import '../functions/api.dart';


// ignore: must_be_immutable
class VocabularyView extends StatefulWidget{

  VocabularyView({
    super.key,});

  @override
  State<VocabularyView> createState() => VocabularyViewState();
}

class VocabularyViewState extends State<VocabularyView> {
final _formKey = GlobalKey<FormState>();
TextEditingController _nameVocabularyController = TextEditingController();
bool _createVocabuluryButtonPressed = false;
String _vocabularyType = 'en_rus';

  

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
                      if(Validator.checkIsTextIsEmpty(text)) {
                    return 'Поле не должно быть пустым';
                  } else if (Validator.checkTextLength(text!)){
                    return 'Допускается длина только ${Config.getMaxAvailablTextLength} символов';
                  } else {
                    return null;
                  }
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
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled))
                return Colors.green;
            })),
          onPressed: _createVocabuluryButtonPressed ? 
          null
          : () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _createVocabuluryButtonPressed = true;
              });
              await Api.insertVocabulary(_nameVocabularyController.text.trim().capitalize(), _vocabularyType, 1);
              _nameVocabularyController.clear();
              Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
            }
          },
          child: _createVocabuluryButtonPressed ? CircularProgressIndicator()
          : Text('Создать словарь')),
          ),
    );
  }
}