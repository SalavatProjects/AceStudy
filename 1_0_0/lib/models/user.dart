class User {
  final int _id;
  final String _uniqKey;

  User(int id, String uniqKey): 
  _id = id, 
  _uniqKey = uniqKey;

  int get getId{
    return _id;
  }

  String get getUniqKey{
    return _uniqKey;
  }
}