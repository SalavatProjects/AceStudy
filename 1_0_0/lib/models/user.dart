class User {
  late int _id;
  late String _name;
  late String _surname;
  late String _phone;
  late String _login;
  
  late String _role;
  late String _roleSlug;
  late double _balance;
  late bool _isTrialActive;
  late String? _teacherStatusEndDate;
  late String? _company;
  late bool _isUpdateAvailable;
  late int _vocabulariesCreated;
  late int _vocabulariesLearned;

  static final User _instance = User._internal();

  factory User() {
    return _instance;
  }

  User._internal();

  void getUserDataFromJson(Map<String, dynamic> json){
    try {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _phone = json['phone'];
    _login = json['login'];
    _role = json['role'];
    _roleSlug = json['role_slug'];
    _balance = double.parse(json['balance']);
    _isTrialActive = json['is_trial_active'];
    _teacherStatusEndDate = json['teacher_status_end_date'];
    _company = json['company'];
    _isUpdateAvailable = json['is_update_available'];
    _vocabulariesCreated = json['vocabularies_created'];
    _vocabulariesLearned = json['vocabularies_learned'];
    } catch(e) {
      print(e);
    }
    
  }
  
  int get getId => _id;
  String get getName => _name;
  String get getSurname => _surname;
  String get getPhone => _phone;
  String get getLogin => _login;
  String get getRole => _role;
  String get getRoleSlug => _roleSlug;
  double get getBalance => _balance;
  bool get getIsTrialActive => _isTrialActive;
  String? get getTeacherStatusEndDate => _teacherStatusEndDate;
  String? get getCompany => _company;
  bool get getIsUpdateAvailable => _isUpdateAvailable;
  int get getVocabulariesCreated => _vocabulariesCreated;
  int get getVocabulariesLearned => _vocabulariesLearned;

  set setIsUpadateAvailable(bool value) {
    _isUpdateAvailable = value;
  }

  set setUserBalance(double value){
    _balance = value;
  }

  set setIsTrialActive(bool value){
    _isTrialActive = value;
  }

  void setVocabulariesCounts(Map<String, dynamic> json){
    _vocabulariesCreated = json['vocabularies_created'];
    _vocabulariesLearned = json['vocabularies_learned'];
  }

  void printUser() {
    print('int id: $_id');
    print('String name: $_name');
    print('String surname: $_surname');
    print('String phone: $_phone');
    print('String login: $_login');
    print('String role: $_role');
    print('String roleSlug $_roleSlug');
    print('double balance: $_balance');
    print('bool isTrialActive: $_isTrialActive');
    print('String? teacherStatusEndDate: $_teacherStatusEndDate');
    print('String? company: $_company');
    print('bool isUpadateAvailable: $_isUpdateAvailable');
    print('int vocabulariesCreated: $_vocabulariesCreated');
    print('int vocabulariesLearned: $_vocabulariesLearned');
  }
}