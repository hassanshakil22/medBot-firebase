import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
    textColor: Colors.white,
    backgroundColor: Colors.blue,
    fontSize: 16,
  );
}
