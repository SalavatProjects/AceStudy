import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';
import 'page_bloc/page_bloc.dart';
import 'pages/vocabulary/voc_bloc/voc_page_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (context) => PageBloc(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => VocPageBloc(),
            ),
          ],
          child: HomeView(),
        ),
      ),
    );
  }
}
