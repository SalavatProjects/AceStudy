import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'home.dart';
import 'pages/login_page.dart';
import 'functions/authorization.dart';
import 'models/user.dart';
import 'config/config.dart';
import 'functions/api.dart';
import 'blocs/page/page_bloc.dart';
import 'blocs/user_vocabulary/voc_bloc.dart';
import 'blocs/train/train_bloc.dart';
import 'blocs/user_statistics/user_statistics_bloc.dart';
import 'blocs/teacher_groups/teacher_groups_bloc.dart';
import 'blocs/group_participants/group_participants_bloc.dart';
import 'blocs/group_vocabularies/group_vocabularies_bloc.dart';
import 'blocs/student_groups/student_groups_bloc.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App>{
  User _user = User();
  Config _config = Config();

  Future<bool> _checkLogin() async {
    await Future.delayed(Duration(seconds: 3));
    _config.getConfigFromJson(await Api.getJsonConfig());
    // _config.printConfig();
      if (await Authorization.isLoggedIn()){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getInt('userId') == null){
          return false;
        } else {
          await Api.checkUserRoleTime(prefs.getInt('userId')!);
          _user.getUserDataFromJson(await Api.getJsonUserData(prefs.getInt('userId')!));
          if (Platform.isAndroid){
            await Api.checkUserSmartphoneType(prefs.getInt('userId')!, 'Android');
          } else if (Platform.isIOS){
            await Api.checkUserSmartphoneType(prefs.getInt('userId')!, 'iOS');
          }
          // _user.printUser();
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
          ),
        BlocProvider(
          lazy: false,
          create: (context) => UserStatisticsBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => TeacherGroupsBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => GroupParticipantsBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => GroupVocabulariesBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => StudentGroupsBloc()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: FutureBuilder(
            future: _checkLogin(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);
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
