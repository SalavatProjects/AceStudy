import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';
import 'blocs/page/page_bloc.dart';
import 'blocs/vocabulary/voc_page_bloc.dart';
import 'blocs/word_translation/word_translation_bloc.dart';
// import 'blocs/test/test_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

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
          create: (context) => WordTranslationBloc())
      ],
      child: MaterialApp(
        home: Scaffold(
          body: const HomeView(),
          ),
        ),
      );
  }
}
