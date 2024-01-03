import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/group_member.dart';
import '../models/user.dart';
import '../functions/modify.dart';
import '../functions/from_json.dart';
import '../functions/api.dart';
import '../blocs/group_participants/group_participants_bloc.dart';


class SearchUserPage extends StatefulWidget {
  List<GroupMember> participants;
  
  SearchUserPage({super.key,
  required this.participants});

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {

  String? _searchedText = null;
  bool _isSearching = false;
  User _user = User();
  List<GroupMember> _participants = [];
  List<GroupMember> _searchedParticipants = [];
  late GroupParticipantsBloc _groupParticipantBloc;

  @override
  void initState(){
    super.initState();
    _participants = List.from(widget.participants);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск участника'),
      centerTitle: true,),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  leading: Icon(Icons.search),
                  padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)),
                  trailing: <Widget>[
                    if (_isSearching)
                    CircularProgressIndicator()
                  ],
                  onChanged: (value) async {
                    // print(controller.text);
                    setState(() {
                    _isSearching = true;
                    
                    });
                    if (value.isNotEmpty)
                    {
                      _searchedText = value.trim().capitalize();
                      // print(await Api.serchParticipants(_user.getId, _searchedText!));
                      _searchedParticipants = FromJson.getParticipants(await Api.serchParticipants(_user.getId, _searchedText!));
                    }
                    
                    setState(() {
                      _isSearching = false;
                    });
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                return List.generate(5, (index) => Text('index $index'));
              },
              ),
          if (_searchedParticipants.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _searchedParticipants.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  tileColor: Colors.grey.shade200,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: const Icon(Icons.person_add),
                  ),
                  title: Text('${_searchedParticipants[index].getName} ${_searchedParticipants[index].getSurname}'),
                  subtitle: Text(_searchedParticipants[index].getLogin),
                  minLeadingWidth: 10,
                  onTap: () {
                    if (!_participants.any((participant) => participant.getLogin == _searchedParticipants[index].getLogin)){
                    _participants.add(_searchedParticipants[index]);
                    _groupParticipantBloc = BlocProvider.of<GroupParticipantsBloc>(context);
                    _groupParticipantBloc.add(GroupParticipantsGettingReadyEvent(participants: _participants));
                    }
                    Navigator.pop(context);
                  },
                ),
              );
          })    
          ],
        ),
          )
          ),
    );
  }
}