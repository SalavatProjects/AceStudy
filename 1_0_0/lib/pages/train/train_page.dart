import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_vocabulary/voc_bloc.dart';
import '../../models/vocabulary.dart';
import '../../models/user.dart';
import '../../widgets/train.dart';


class TrainPage extends StatefulWidget {
  const TrainPage({ Key? key }) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  User _user = User();

  List<Vocabulary>? _vocabularies;

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
              _vocabularies = state.vocabularies;
              // print(_vocabularies);
              if (_vocabularies!.isNotEmpty)
              {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Train(userId: _user.getId,
                  vocabularies: _vocabularies!,
                  groupId: null,),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('У вас еще нет ни одного словаря, давайте создадим!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,),
                );
              }
              
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
    )
    );
  }
}