import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class FlushbarView{
  static Flushbar buildFlushbarWithTitle(BuildContext context, String message){
    return Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.blue.shade900,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue.shade300,
      ),
      margin: EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(8.0),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}