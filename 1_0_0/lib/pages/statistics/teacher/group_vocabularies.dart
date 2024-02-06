import 'package:flutter/material.dart';

import '../../../models/vocabulary.dart';
import 'student_statistics_by_vocabulary.dart';

class GroupVocabularies extends StatelessWidget {
int groupId;
List<Vocabulary> vocabularies;

GroupVocabularies({super.key,
required this.groupId,
required this.vocabularies});

  @override
  Widget build(BuildContext context){
    // print(vocabularies);
    return Scaffold(
      appBar: AppBar(
        title: Text('Словари группы'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900]),
          ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: 
              vocabularies.isNotEmpty ?
              ListView.builder(
                itemCount: vocabularies.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      tileColor: Colors.grey.shade100,
                      leading: vocabularies[index].getIcon == 'none'
                        ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                        child: const Icon(Icons.book_outlined),)
                        :
                        Padding(padding: EdgeInsets.only(top: 8.0),
                        child: Icon(Icons.ac_unit),),
                        title: Text(vocabularies[index].getName),
                        onTap: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (BuildContext context) => StudentStatisticsByVocabulary(
                            groupId: groupId, vocabulary: vocabularies[index])));
                        },
                        ),
                  );
                }) 
                :
                Center(
                    child: Text('В группе нет словарей!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,),
                  ),
            ),),),
    );
  }
}