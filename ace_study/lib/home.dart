import 'package:flutter/material.dart';

import 'vocabularies.dart';
import 'drawer.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}


class HomeViewState extends State<HomeView> {
  
final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("AceStudy",
       style: TextStyle(color: Colors.white,),),
       centerTitle: true,
       leading: IconButton(
        icon: Icon(Icons.menu, size: 26,), color: Colors.white,
        onPressed: () {
          _key.currentState!.openDrawer();
        },),
        
       backgroundColor: Colors.deepPurple[900],
       ),
       
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Center(child: Text("Добро пожаловать, {user_name}!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500,
             color: Colors.blueGrey[800]),),)
          ],),
      ),
        drawer: DrawerView(),
    );
    
  }
}