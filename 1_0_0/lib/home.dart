import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/config.dart';
import 'widgets/drawer.dart';
import 'blocs/page/page_bloc.dart';
import 'utils/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // PageBloc _pageBloc = PageBloc();
  @override
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
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            Map <String, String> appbarTitles = {
              'main' : settings_language[app_language]!.main_page_title,
              'vocabularies' : settings_language[app_language]!.vocabularies_page_title,
              'settings' : settings_language[app_language]!.settings_page_title,
              };
            return AppBar(
              title: Text(
                appbarTitles[Config.app_page]!,
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
            return Config.pages[Config.app_page]!;
          } else {
            return Config.pages[Config.app_page]!;
          }
        },
      ),
      drawer: const DrawerView(),
    );
  }
}
