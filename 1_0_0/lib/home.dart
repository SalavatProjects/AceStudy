import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'config/config.dart';
import 'widgets/drawer.dart';
import 'blocs/page/page_bloc.dart';
import 'utils/settings.dart';
import '../models/user.dart';
import '../functions/api.dart';
import '../functions/modify.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  User _user = User();
  Config _config = Config();
  bool _isBackButtonPressed = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add((bool stopDefaultButtonEvent, RouteInfo routeInfo,) {
      if (routeInfo.ifRouteChanged(context)) {
        return false;
      } else {      
        onPopScope(context,_isBackButtonPressed);
          _isBackButtonPressed = true;
          Future.delayed(Duration(seconds: 4), () {
            _isBackButtonPressed = false;
          });
      return true;
      }
    }, name: 'backButton', context: context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_user.getIsUpdateAvailable) {
      showDialog<String>(context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Внимание'),
                      content: Text('На приложение вышло обновление, не забудьте его обновить, чтобы получить доступ к новым функциям и возможностям!'),
                      actions: <Widget>[
                        TextButton(onPressed: () async {
                          await Api.setUpdateToFalse(_user.getId);
                          _user.setIsUpadateAvailable = false;
                          Navigator.pop(context);
                        }, 
                        child: Text('Ок')),
                      ],
                    ));
    }
    });
    
  }

    @override
  void dispose() {
    BackButtonInterceptor.removeByName('backButton');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            Map <String, String> appbarTitles = {
              'main' : settings_language[app_language]!.main_page_title,
              'vocabularies' : settings_language[app_language]!.vocabularies_page_title,
              'settings' : settings_language[app_language]!.settings_page_title,
              'train' : 'Тренировка',
              'profile' : 'Профиль',
              'user_statistics' : 'Статистика пользователя',
              'guide' : 'Путеводитель',
              'groups_teacher' : 'Группы',
              'groups_student' : 'Группы',
              'students_statistics' : 'Статистика',
              };
            return AppBar(
              title: Text(
                appbarTitles[_config.getAppPage]!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 26,
                ),
                color: Colors.white,
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
              backgroundColor: Colors.deepPurple[900],
            );
          },
        ),
      ),
      body: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          if (state is PageChanged) {
            return _config.getPages[_config.getAppPage]!;
          } else {
            return _config.getPages[_config.getAppPage]!;
          }
        },
      ),
      drawer: const DrawerView(),
    );
  }
}
