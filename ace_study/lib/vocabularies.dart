import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'vocabulary.dart';

class VocabulariesView extends StatefulWidget{
  VocabulariesView({super.key});

  @override
  State<VocabulariesView> createState() => VocabulariesViewState();
}

class VocabulariesViewState extends State<VocabulariesView> {
var connection;

late TextEditingController _nameVocabularyController;
final _formKey = GlobalKey<FormState>();

Future open_connection() async {
  connection = PostgreSQLConnection(
    "10.0.2.2",
     5432,
      "study_english",
       username: "postgres",
        password: "postgres",
        // timeoutInSeconds: 30,
        // queryTimeoutInSeconds: 30,
        // timeZone: 'UTC',
        // isUnixSocket: false,
        // allowClearTextPassword: false,
        // replicationMode: ReplicationMode.none
        );
  await connection.open();
} 

  

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

  // String _validateText(String value) {
  //   if (value.isEmpty) {
  //     return "Поле не должно быть пустым";
  //   }
  //   return "null";
  // }

  Future<void> _createVocabulary(BuildContext context){
    return showDialog<void>(context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Название словаря'),
        content: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
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
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
             child: Text("Отмена")),
             
             TextButton(onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                 VocabularyView(vocabularyName: _nameVocabularyController.text,)),
              );
              }
              
             },
            child: Text("Создать"))
          ],
      );
    } );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои словари'),
        centerTitle: true,
      ),
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  // await open_connection();
                  // await connection.query("INSERT INTO test.dictionary (dictionary_name) VALUES ('test_name')");
                  _nameVocabularyController.clear();
                  _createVocabulary(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_sharp),
                    Text('Создать словарь'),
                  ]),
                  ),
            ),
            Divider(thickness: 1,)
          ]),
          )
          ),
    );
  }
}