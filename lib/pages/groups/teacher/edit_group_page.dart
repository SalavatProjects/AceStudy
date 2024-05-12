import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/group_participants/group_participants_bloc.dart';
import '../../../blocs/group_vocabularies/group_vocabularies_bloc.dart';
import '../../../models/group.dart';
import '../../../models/group_member.dart';
import '../../../models/vocabulary.dart';
import '../../../utils/validators.dart';
import '../../../functions/api.dart';
import '../../../home.dart';
import '../../../functions/modify.dart';
import 'search_user_page.dart';
import 'add_vocabulary.dart';

class EditGroupPage extends StatefulWidget {
  Group group;

  EditGroupPage({super.key,
  required this.group});

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final _formKeyForNameGroup = GlobalKey<FormState>();
  final _formKeyForUser = GlobalKey<FormState>();
  TextEditingController _groupNameController = TextEditingController();
  bool _submitButtonPressed = false;
  List<GroupMember> _groupMembers = [];
  List<Vocabulary> _vocabularies = [];
  late GroupParticipantsBloc _groupParticipantsBloc;
  late GroupVocabulariesBloc _groupVocabulariesBloc;
  List<int> _vocabulariesId = [];
  List<int> _groupMembersId = [];

  @override
  void initState() {
    super.initState();
    _groupNameController.text = widget.group.getName;
    _groupParticipantsBloc = BlocProvider.of<GroupParticipantsBloc>(context);
    _groupParticipantsBloc.add(GroupParticipantsGettingReadyEvent(participants: widget.group.getMembers));
    _groupVocabulariesBloc = BlocProvider.of<GroupVocabulariesBloc>(context);
    _groupVocabulariesBloc.add(GroupVocabulariesGettingReadyEvent(vocabularies: widget.group.getVocabularies));
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Редактирование группы'),
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.deepPurple[900],),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
      },),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKeyForNameGroup,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      label: Text('Название группы')),
                      validator: (text) {
                        if (Validator.checkIsTextIsEmpty(text)){
                          return 'Поле не должно быть пустым';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          _submitButtonPressed = false;
                        });
                      },
                      )
                      ),
                      SizedBox(height: 20,),
                      
                      
                      Text('Участники',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),),
                      
                      BlocBuilder<GroupParticipantsBloc, GroupParticipantsState>(builder: (context, state) {
                        if (state is GroupParticipantsIsReady) {
                          _groupMembers = state.participants;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            TextButton(onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: 
                            (BuildContext context) => SearchUserPage(participants: _groupMembers)));
                            }, 
                            child: Text('Добавить участника')),
                            if (_groupMembers.isNotEmpty)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _groupMembers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text('${_groupMembers[index].getName} ${_groupMembers[index].getSurname}'),
                                  subtitle: Text(_groupMembers[index].getLogin),
                                  minLeadingWidth: 10,
                                  trailing: IconButton(icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _groupMembers.removeAt(index);
                                    _groupParticipantsBloc.add(GroupParticipantsGettingReadyEvent(participants: _groupMembers));
                                  },),
                                );
                              })
                            else
                            Center(
                              child: Text('Нет участников'),)
                          
                            ]
                          );
                          
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),);
                        }
                      }),
                      Divider(thickness: 1),
                      Text('Словари',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),),
                      BlocBuilder<GroupVocabulariesBloc, GroupVocabulariesState>(
                        builder: (context, state) {
                        if (state is GroupVocabulariesIsReady)
                        {
                          _vocabularies = state.vocabularies;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (BuildContext context) => AddVocabulary(vocabularies: _vocabularies)));
                              }, 
                              child: Text('Добавить словарь')),
                              if (_vocabularies.isNotEmpty)
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _vocabularies.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: _vocabularies[index].icon == 'none'
                                      ? Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: const Icon(Icons.book_outlined),
                                      )
                                      : Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: const Icon(Icons.ac_unit),
                                      ),
                                    title: Text(_vocabularies[index].getName),
                                    subtitle: Text('Кол-во слов: ${_vocabularies[index].getWordsCount}'),
                                    minLeadingWidth: 10,
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        showDialog<String>(context: context, builder: (BuildContext context) => 
                                        AlertDialog(
                                          title: Text('Удаление словаря'),
                                          content: Text('Внимание! При сохранении группы вся статистика словаря ${_vocabularies[index].getName} очиститься из этой группы',
                                          textAlign: TextAlign.center,),
                                          actions: <Widget>[
                                            TextButton(onPressed: () {
                                              Navigator.pop(context);
                                            }, child: Text('Отмена')),
                                            TextButton(onPressed: () async {
                                              _vocabularies.removeAt(index);
                                              _groupVocabulariesBloc.add(GroupVocabulariesGettingReadyEvent(vocabularies: _vocabularies));
                                              Navigator.pop(context);
                                            }, child: Text('Ок'))
                                          ],
                                        ));
                                        
                                      },),
                                  );
                                }) else 
                                Center(child: Text('Нет словарей'),
                                ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                      
              ]),
              ),
        )
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: ElevatedButton(onPressed: _submitButtonPressed ?
              null :
              () async {
                if (_formKeyForNameGroup.currentState!.validate()) {
                  setState(() {
                    _submitButtonPressed = true;
                  });
                  _groupMembers.forEach((element) { 
                    _groupMembersId.add(element.getId);
                  });
                  _vocabularies.forEach((element) {
                    _vocabulariesId.add(element.getId);
                  });
                  await Api.updateGroup(widget.group.getId, _groupNameController.text.trim().capitalize(), _vocabulariesId, _groupMembersId);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
                }
              },
              child: Text('Сохранить'),
              ),
              ),
    );
  }
}