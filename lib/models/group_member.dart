class GroupMember{
  int id;
  String name;
  String surname;
  String login;
  String phone;

  GroupMember({
    required this.id,
    required this.name,
    required this.surname,
    required this.login,
    required this.phone
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'], 
      name: json['name'], 
      surname: json['surname'], 
      login: json['login'], 
      phone: json['phone']);
  }

  int get getId => id;
  String get getName => name;
  String get getSurname => surname;
  String get getLogin => login;
  String get getPhone => phone;

  @override
  String toString() {
    return 'GroupMember: int id $id, String name $name, String surname $surname, ' +
    'String login $login, String phone $phone';
  }
}