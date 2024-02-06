import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';


import 'home.dart';
import 'pages/auth_reg/login_page.dart';
import 'functions/authorization.dart';
import 'models/user.dart';
import 'config/config.dart';
import 'config/constants.dart';
import 'functions/api.dart';
import 'blocs/page/page_bloc.dart';
import 'blocs/user_vocabulary/voc_bloc.dart';
import 'blocs/train/train_bloc.dart';
import 'blocs/user_statistics/user_statistics_bloc.dart';
import 'blocs/teacher_groups/teacher_groups_bloc.dart';
import 'blocs/group_participants/group_participants_bloc.dart';
import 'blocs/group_vocabularies/group_vocabularies_bloc.dart';
import 'blocs/student_groups/student_groups_bloc.dart';
import 'blocs/student_statistics_by_vocabulary/students_statistics_by_vocabulary_bloc.dart';
import 'blocs/student_group_statistic/student_group_statistic_bloc.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App>{
  User _user = User();
  Config _config = Config();
  

  Future<bool> _checkLogin() async {
    // await Future.delayed(Duration(seconds: 3));
    _config.getConfigFromJson(await Api.getJsonConfig());
    // _config.printConfig();

    // var client = HttpClient();
    // HttpClientRequest request = await client.get('http://studyenglish/api/v1/get_user_data?user_id=5', 80, '/');
    /* HttpClientRequest request = await client.getUrl(Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 80,
        path: "api/v1/get_user_data",
        query: 'user_id=5')); */
        /* request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

        HttpClientResponse response = await request.close();
        var responseBody = await response.transform(utf8.decoder).join();
        var jsonData = jsonDecode(responseBody);*/
        /* print(Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 80,
        path: "api/v1/get_user_data",
        query: 'user_id=5')); */
        // print(jsonData); 
        
  /* var response = await http.post(Uri.parse('http://5.35.16.108/api/v1/get_guide'));
  print(response.body); */

      // print(await Api.getJsonUserData(5));
      if (await Authorization.isLoggedIn()){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // print(prefs.getInt('userId'));
        if (prefs.getInt('userId') == null){
          return false;
        } else {
          // print('qwer');
          if (!await Api.checkIfUserExist(prefs.getInt('userId')!))
          {
            await prefs.remove('userId');
            return false;
          }
        
          await Api.checkUserRoleTime(prefs.getInt('userId')!);
          // print('hi');
          _user.getUserDataFromJson(await Api.getJsonUserData(prefs.getInt('userId')!));
          if (Constants.getAppVersion != _user.getAppVersion)
          {
            await Api.setUserAppVesrion(_user.getId, Constants.getAppVersion);
          }
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
        BlocProvider(
          lazy: false,
          create: (context) => StudentsStatisticsByVocabularyBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => StudentGroupStatisticBloc())
      ],
      child: MaterialApp(
        routes: {
          '/home' :(context) => HomeView()
        },
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
                return Center(child: Text('AceStudy'));
              }
            },
          ), 
          // const HomeView(),
          ),
        ),
      );
  }
}
