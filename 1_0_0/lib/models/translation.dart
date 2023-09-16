class Translation {
  String name;
  late int id;
  late String language;
  
  Translation({
    required this.id,
    required this.name,
    required this.language
  });
/*   Translation(String name):
    _name = name;
    
  set setFull(Map<String, dynamic> json){
    _id = json['id'];
    _name = json['name'];
    _language = json['language'];
  } */
  
  @override
  String toString() {
    // TODO: implement toString
    return 'Translation\n int id: $id\nString name: $name\nString language: $language\n\n';
  }
}