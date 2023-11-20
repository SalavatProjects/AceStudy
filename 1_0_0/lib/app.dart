import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'pages/login_page.dart';
import 'functions/authorization.dart';
import 'models/user.dart';
import 'functions/api.dart';
import 'blocs/page/page_bloc.dart';
import 'blocs/user_vocabulary/voc_bloc.dart';
import 'blocs/train/train_bloc.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App>{
  Future<bool> _checkLogin() async {
    await Future.delayed(Duration(seconds: 5));
      if (await Authorization.isLoggedIn()){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getInt('userId') == null){
          return false;
        } else {
          User user = User();
          user.getUserDataFromJson(await Api.getJsonUserData(prefs.getInt('userId')!));
          return true;
        }
      } else {
        return false;
      }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => PageBloc(),
              ),
        BlocProvider(
          lazy: false,
          create: (context) => VocPageBloc(),
              ),
        BlocProvider(
          lazy: false,
          create: (context) => TrainBloc()
          )
      ],
      child: MaterialApp(
        home: Scaffold(
          body: FutureBuilder(
            future: _checkLogin(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data){
                  return HomeView();
                } else {
                  return LoginPage();
                }
              } else {
                return Center(child: Text('Приветствие'));
              }
            },
          ), 
          // const HomeView(),
          ),
        ),
      );
  }
}
