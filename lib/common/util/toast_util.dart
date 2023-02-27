import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class ToastUtil {
  static void showToast(String message, {Duration duration = Toast.LENGTH_SHORT, BuildContext? context}) {
    toast(message);
  }
}
