import 'package:flutter/material.dart';

import 'vocabularies.dart';

class DrawerView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: SafeArea(child: 
          Column(children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: DrawerHeader(
                child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.blueGrey, 
                  ),
                  color: Colors.white),
                child: 
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Row(
                    children: [
                      Icon(Icons.person,
                      color: Colors.blueGrey[800],
                      size: 24,),
                      Text(' {user_name}',
                       style: TextStyle(color: Colors.blueGrey[800],
                       fontSize: 16, fontWeight: FontWeight.w500),)
                    ],
                  )),
                )
                ,),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 240,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VocabulariesView()));
                },
                 icon: Icon(Icons.format_color_text_rounded, size: 26,),
                  label: Text('Мои словари',
                  style: TextStyle(fontSize: 20),)),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 240,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                 icon: Icon(Icons.notes_rounded, size: 26,),
                  label: Text('Мои группы',
                  style: TextStyle(fontSize: 20),)),
            ),
            
          ],)),
        );
  }
} 