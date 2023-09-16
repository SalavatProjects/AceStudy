import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/settings.dart';
import '../models/vocabulary.dart';
import '../blocs/vocabulary/voc_page_bloc.dart';
import '../utils/postgres_conn.dart';
import '../functions/server.dart';
import 'vocabulary_page.dart';
import 'words_page.dart';

class VocabulariesView extends StatefulWidget {
  const VocabulariesView({super.key});

  @override
  State<VocabulariesView> createState() => VocabulariesViewState();
}

class VocabulariesViewState extends State<VocabulariesView> {
  late List<Vocabulary> _vocabularies;
  @override
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
                _vocabularies = Server.getUserVocabularies(state.vocabularies);
                return SingleChildScrollView(
                child: Column(children: [
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(top: 10.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VocabularyView()));
                      },
                      child: ListTile(
                        leading: const Icon(Icons.add_circle_outline_sharp),
                        title: Text(
                            settings_language[app_language]!.create_vocabulary),
                        minLeadingWidth: 10,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ListView.builder(
                    itemCount: _vocabularies.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: _vocabularies[index].icon == null ? const Icon(Icons.book_outlined) : const Icon(Icons.ac_unit),
                        title: Text(_vocabularies[index].name),
                        subtitle: Text('${_vocabularies[index].type} Кол-во слов: ${_vocabularies[index].words_count}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => WordsView(
                                vocabulary_id: _vocabularies[index].id,
                                vocabulary_type: _vocabularies[index].type_slug,
                                )));
                            },
                            icon: const Icon(Icons.create_rounded)),
                            
                            IconButton(onPressed: () async {
                              await Connect.open_connection();
                              await Connect.connection.query('DELETE FROM study_english.dictionary ' 'WHERE id = ${_vocabularies[index].id}');
                              BlocProvider.of<VocPageBloc>(context)
                              .add(VocabulariesGettingReadyEvent());
                            },
                            icon: const Icon(Icons.delete))
                          ]),
                      );
                    })
                ]),
              );
              } else {
                return const CircularProgressIndicator();
                
              }
              
            },
          )),
    );
  }
}
