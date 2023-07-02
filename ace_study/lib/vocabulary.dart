import 'package:flutter/material.dart';

import 'word.dart';

class VocabularyView extends StatefulWidget{

  String vocabularyName;

  VocabularyView({
    super.key,
    required this.vocabularyName});

  @override
  State<VocabularyView> createState() => VocabularyViewState();
}

class VocabularyViewState extends State<VocabularyView> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vocabularyName),
        centerTitle: true,),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                 WordView()),
              );
                },
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_sharp),
                    Text('Слово'),
                  ]),
                  ),
               ),
            ),
             Divider(thickness: 1,),
             
          ],
          ),
      )),
    );
  }
}