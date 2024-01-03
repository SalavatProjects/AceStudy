import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/settings.dart';
import '../blocs/page/page_bloc.dart';
import '../models/user.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    User _user = User();
    return Drawer(
      child: SafeArea(child: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          return Column(
            children: [
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                          child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blueGrey[800],
                            size: 24,
                          ),
                          Text(
                            ' ${_user.getName}',
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
              ),
              DrawerButtons(
                button_name: 'Профиль',
                icon: Icons.account_circle,
                page_name: 'profile',
              ),
              DrawerButtons(
                button_name: settings_language[app_language]!.my_vocabularies,
                icon: Icons.format_color_text_rounded,
                page_name: 'vocabularies',
              ),
              DrawerButtons(button_name: 'Тренировка', 
              icon: Icons.album_outlined, 
              page_name: 'train'),
              if (_user.getRoleSlug == 'teacher')
              DrawerButtons(button_name: 'Группы', 
              icon: Icons.group, 
              page_name: 'groups_teacher'),
              if (_user.getRoleSlug == 'student')
              DrawerButtons(
                button_name: 'Группы',
                icon: Icons.group,
                page_name: 'groups_student'
              ),
              if (_user.getRoleSlug == 'student')
              DrawerButtons(button_name: 'Статистика', 
              icon: Icons.line_weight, 
              page_name: 'user_statistics'),
              if (_user.getRoleSlug == 'teacher')
              DrawerButtons(button_name: 'Статистика', 
              icon: Icons.line_weight, 
              page_name: 'students_statistics'),
              DrawerButtons(button_name: 'Путеводитель', 
              icon: Icons.format_list_bulleted, 
              page_name: 'guide'),
              DrawerButtons(button_name: settings_language[app_language]!.settings,
              icon: Icons.settings,
              page_name: 'settings',
              )
            ],
          );
        },
      )),
    );
  }
}

// ignore: must_be_immutable
class DrawerButtons extends StatelessWidget {
  String button_name;
  String page_name;
  IconData icon;
  DrawerButtons(
      {super.key,
      required this.button_name,
      required this.icon,
      required this.page_name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: SizedBox(
        width: 240,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<PageBloc>(context)
                  .add(PageChangeEvent(page_name: page_name));
              Navigator.pop(context);    
            },
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icon,
                  size: 26,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(button_name, style: const TextStyle(fontSize: 20),),
                )
              ]),
            /* icon: Icon(
              icon,
              size: 26,
            ),
            label: Text(
              button_name,
              style: const TextStyle(fontSize: 20),
            ) */
            ),
      ),
    );
  }
}
