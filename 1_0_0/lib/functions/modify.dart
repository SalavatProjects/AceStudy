extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}

Map<String, int> convertToIntMap(Map<String, dynamic> dynamicMap){
  Map<String, int> intMap = {};
  for (var entry in dynamicMap.entries)
  {
    intMap[entry.key.toString()] = int.parse(entry.value.toString());
  }
  return intMap;
}