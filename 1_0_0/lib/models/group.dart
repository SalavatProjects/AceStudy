import 'group_member.dart';
import 'vocabulary.dart';
import '../functions/from_json.dart';

class Group{
  int id;
  String name;
  String icon;
  int creatorId;
  String createdAt;
  List<GroupMember> members;
  List<Vocabulary> vocabularies;

  Group({
    required this.id,
    required this.name,
    required this.icon,
    required this.creatorId,
    required this.createdAt,
    required this.members,
    required this.vocabularies,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'], 
      name: json['name'], 
      icon: json['icon'], 
      creatorId: json['creator_id'], 
      createdAt: json['created_at_string'],
      members: FromJson.getParticipants(json['group_members']),
      vocabularies: FromJson.getVocabularies(json['group_dictionaries']),
      );
  }
  
  int get getId => id;
  String get getName => name;
  String get getIcon => icon;
  int get getCreatorId => creatorId;
  String get getCreatedAt => createdAt;
  List<GroupMember> get getMembers => members;
  List<Vocabulary> get getVocabularies => vocabularies;

  @override
  String toString() {
    return 'Group: int id: $id, String name $name, String icon $icon, ' +
    'int creatorId $creatorId, String createdAt $createdAt, ' + 
    'List<GroupMember> members $members, List<Vocabulary> vocabularies $vocabularies';
  }
}