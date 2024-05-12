import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/flushbar.dart';

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

void onPopScope(BuildContext context, bool isBackButtonPressed) {
  if (isBackButtonPressed)
  {
    // print('isBackButtonPressed: ${isBackButtonPressed}');
    SystemChannels.platform.invokeListMethod('SystemNavigator.pop'); 
  } else {
    // print('isBackButtonPressed: ${isBackButtonPressed}');
    FlushbarView.buildFlushbarWithTitle(context, 'Нажмите ещё раз для выхода!');
  }
  // if (DateTime.now().difference(currentBackPressTime) < Duration(seconds: 4))
}