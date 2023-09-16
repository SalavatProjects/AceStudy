class Vocabulary{
  int id;
  String name;
  String? icon;
  String type_slug;
  String type;
  int words_count;
  Vocabulary({
    required this.id,
    required this.name,
    required this.icon,
    required this.type_slug,
    required this.type,
    required this.words_count,
  });
  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    late String currentType;
    switch (json['type']) {
      case 'en_rus':
        currentType = 'Ан/рус';
        break;
      case 'rus_en':
        currentType = 'Рус/ан';
        break;
    }
    return Vocabulary(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    type_slug: json['type'],
    type: currentType,
    words_count: json['words_count']);
  }

  @override
  String toString() {
    return 'Vocabulary: int id $id, String name $name, String? icon $icon, String type $type, int words_count $words_count;';
  }

}