import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config.dart';
import 'drawer.dart';
import 'page_bloc/page_bloc.dart';
import 'settings.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // PageBloc _pageBloc = PageBloc();
  void initState() {
    super.initState();
    // PageBloc().add(PageChangeEvent(page_name: 'main'));
    // _pageBloc = PageBloc();
    // _pageBloc.add(PageChangeEvent(page_name: 'main'));
    // app_page = 'main';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            Map <String, String> appBar_titles = {
              'main' : settings_language[app_language]!.main_page_title,
              'vocabularies' : settings_language[app_language]!.vocabularies_page_title,
              'settings' : settings_language[app_language]!.settings_page_title,
              };
            return AppBar(
              title: Text(
                appBar_titles[app_page]!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
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
            return pages[app_page]!;
          } else {
            return pages[app_page]!;
          }
        },
      ),
      drawer: DrawerView(),
    );
  }
}
