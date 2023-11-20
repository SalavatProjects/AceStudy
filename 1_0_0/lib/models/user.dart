class User {
  late int _id;
  late String _name;
  late String _surname;
  late String _phone;
  late String _login;
  late String _role;
  late String _roleSlug;
  late String? _company;
  late bool _isUpdateAvailable;

  static final User _instance = User._internal();

  factory User() {
    return _instance;
  }

  User._internal();

  void getUserDataFromJson(Map<String, dynamic> json){
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _phone = json['phone'];
    _login = json['login'];
    _role = json['role'];
    _roleSlug = json['role_slug'];
    _company = json['company'];
    _isUpdateAvailable = json['is_update_available'];
  }
  
  int get getId => _id;
  String get getName => _name;
  String get getSurname => _surname;
  String get getPhone => _phone;
  String get getLogin => _login;
  String get getRole => _role;
  String get getRoleSlug => _roleSlug;
  String? get getCompany => _company;
  bool get getIsUpdateAvailable => _isUpdateAvailable;

  void printUser() {
    print('int id: $_id');
    print('String name: $_name');
    print('String surname: $_surname');
    print('String phone: $_phone');
    print('String login: $_login');
    print('String role: $_role');
    print('String roleSlug $_roleSlug');
    print('String? company: $_company');
    print('bool isUpadateAvailable: $_isUpdateAvailable');
  }
}