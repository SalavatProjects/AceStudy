import 'package:ace_study/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'vocabulary.dart';
import 'package:ace_study/settings.dart';
import 'data.dart';
import 'voc_bloc/voc_page_bloc.dart';
import 'package:ace_study/api.dart';

class VocabulariesView extends StatefulWidget {
  VocabulariesView({super.key});

  @override
  State<VocabulariesView> createState() => VocabulariesViewState();
}

class VocabulariesViewState extends State<VocabulariesView> {

  void initState() {
    super.initState();
    BlocProvider.of<VocPageBloc>(context)
                .add(VocabulariesGettingReadyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocBuilder<VocPageBloc, VocPageState>(
            builder: (context, state) {
              if (state is VocabulariesIsReady)
              {
                return SingleChildScrollView(
                child: Column(children: [
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(top: 10.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VocabularyView()));
                      },
                      child: ListTile(
                        leading: Icon(Icons.add_circle_outline_sharp),
                        title: Text(
                            settings_language[app_language]!.create_vocabulary),
                        minLeadingWidth: 10,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ListView.builder(
                    itemCount: vocabularies.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int _index) {
                      return ListTile(
                        leading: vocabularies.data[_index].icon == null ? Icon(Icons.book_outlined) : Icon(Icons.ac_unit),
                        title: Text(vocabularies.data[_index].name),
                        subtitle: Text('${vocabularies.data[_index].type} Кол-во слов: ${vocabularies.data[_index].words_count}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () {},
                            icon: Icon(Icons.create_rounded)),
                            IconButton(onPressed: () async {
                              await open_connection();
                              await connection.query('DELETE FROM test.dictionary ' +
                              'WHERE id = ${vocabularies.data[_index].id}');
                              BlocProvider.of<VocPageBloc>(context)
                              .add(VocabulariesGettingReadyEvent());
                            },
                            icon: Icon(Icons.delete))
                          ]),
                      );
                    })
                ]),
              );
              } else {
                return CircularProgressIndicator();
              }
              
            },
          )),
    );
  }
}
