class Translation {
  int id;
  String name;
  String language;
  
  Translation({
    required this.id,
    required this.name,
    required this.language
  });
  
  factory Translation.fromJson(Map<String, dynamic> json){
    return Translation(
    id: json['id'], 
    name: json['name'], 
    language: json['language']);
  }

  int get getId {return id;}
  String get getName {return name;}
  String get getLanguage {return language;}

  @override
  String toString() {
    // TODO: implement toString
    return 'Translation: int id: $id, String name: $name, String language: $language';
  }
}