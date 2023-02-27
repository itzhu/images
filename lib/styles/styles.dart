/*摆脱冷气，只是向上走，不必听自暴自弃者流的话。*/

import 'dart:io';

import 'package:flutter/material.dart';

///@name  : styles
///@author: create by  itzhu |  2022/5/31
///@desc  : App主题
class MyAppTheme {
  ///字体
  String fontFamily = "AlibabaPuHuiTi";

  ///主题颜色
  Color primaryColor = deepOrangeCopy;
  ///主题颜色
  MaterialColor primarySwatch = deepOrangeCopy;

  ///标题栏文字颜色
  Color titleTextColor = Colors.white;

  ///标题栏高度
  double appBarHeight = 56;

  ///[windowTitleBarHeight] 桌面平台标题栏高度
  ///[phoneTitleBarHeight] 移动平台标题栏高度
  void initTitleBarHeight(
      double? windowTitleBarHeight, double? phoneTitleBarHeight) {
    if (Platform.isIOS || Platform.isAndroid) {
      if (phoneTitleBarHeight != null) {
        appBarHeight = phoneTitleBarHeight;
      }
    } else {
      if (windowTitleBarHeight != null) {
        appBarHeight = windowTitleBarHeight;
      }
    }
  }

  static const MaterialColor deepOrangeCopy = MaterialColor(
    _deepOrangePrimaryValue,
    <int, Color>{
      50: Color(0xFFFBE9E7),
      100: Color(0xFFFFCCBC),
      200: Color(0xFFFFAB91),
      300: Color(0xFFFF8A65),
      400: Color(0xFFFF7043),
      500: Color(_deepOrangePrimaryValue),
      600: Color(0xFFF4511E),
      700: Color(0xFFE64A19),
      800: Color(0xFFD84315),
      900: Color(0xFFBF360C),
    },
  );
  static const int _deepOrangePrimaryValue = 0xAA3C3F41;


  static const color_E9E9E9 = Color(0xFFE9E9E9);
}


