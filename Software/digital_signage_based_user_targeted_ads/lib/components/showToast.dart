import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({String message, bool short = true, bgColor = Colors.blueGrey, txtColor = Colors.white}) {
  Fluttertoast.showToast(
      msg: message,
      // toastLength: Toast.LENGTH_SHORT,
      toastLength: short ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      backgroundColor: bgColor,
      textColor: txtColor);
}
