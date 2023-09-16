import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/settings.dart';
import '../blocs/page/page_bloc.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
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
                            ' {user_name}',
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
              const SizedBox(
                height: 20,
              ),
              DrawerButtons(
                button_name: settings_language[app_language]!.main,
                icon: Icons.account_circle,
                page_name: 'main',
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerButtons(
                button_name: settings_language[app_language]!.my_vocabularies,
                icon: Icons.format_color_text_rounded,
                page_name: 'vocabularies',
              ),
              const SizedBox(
                height: 20,
              ),
              // DrawerButtons(
              //   button_name: settings_language[app_language]!.my_groups,
              //   icon: Icons.notes_rounded,
              //   page_name: 'groups',
              // ),
              // SizedBox(
              //   height: 20,
              // ),
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
    return SizedBox(
      width: 240,
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () {
            BlocProvider.of<PageBloc>(context)
                .add(PageChangeEvent(page_name: page_name));
            Navigator.pop(context);    
          },
          icon: Icon(
            icon,
            size: 26,
          ),
          label: Text(
            button_name,
            style: const TextStyle(fontSize: 20),
          )),
    );
  }
}
