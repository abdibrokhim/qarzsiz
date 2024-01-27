import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String? message, required Color bgColor, required String webBgColor}){
  Fluttertoast.showToast(
      msg: message ?? 'An has error occurred.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: webBgColor
  );
}