import 'dart:io';

import 'package:images/pages/views/desktop/desktop_fun.dart';
import 'package:images/pages/views/desktop/win_titlebars.dart';
import 'package:images/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

import 'pages/page_splash.dart';

MyAppTheme myAppTheme = MyAppTheme();

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    myAppTheme.initTitleBarHeight(HEIGHT_WIN_BAR, null);
    await DesktopFun.init();
  } else {
    myAppTheme.initTitleBarHeight(null, 48);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String TAG = "MyApp";

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // 在组件渲染之后，再覆写状态栏颜色
      // 如果使用了APPBar，则需要修改brightness属性
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return OverlaySupport.global(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 统一指定应用的字体。
        fontFamily: myAppTheme.fontFamily,
        primarySwatch: myAppTheme.primarySwatch,
        // scaffold组件的背景颜色
        scaffoldBackgroundColor: Colors.transparent,


        /*```
       displayLarge = displayLarge ?? headline1,
       displayMedium = displayMedium ?? headline2,
       displaySmall = displaySmall ?? headline3,
       headlineMedium = headlineMedium ?? headline4,
       headlineSmall = headlineSmall ?? headline5,
       titleLarge = titleLarge ?? headline6,
       titleMedium = titleMedium ?? subtitle1,
       titleSmall = titleSmall ?? subtitle2,
       bodyLarge = bodyLarge ?? bodyText1,
       bodyMedium = bodyMedium ?? bodyText2,
       bodySmall = bodySmall ?? caption,
       labelLarge = labelLarge ?? button,
       labelSmall = labelSmall ?? overline;
       ``` */
        // textTheme: const TextTheme(
        //   headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        //   headline2: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, color: Colors.white),
        //   headline3: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, color: Colors.white),
        //
        //   headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, color: Colors.white),
        //   headline5: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.white),
        //   headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200, color: Colors.white),
        //   bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200, color: Colors.white),
        //   bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200, color: Colors.white),
        //   caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200, color: Colors.white),
        // ),

        //appbar样式设置
        appBarTheme: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? AppBarTheme(
                //背景颜色
                // backgroundColor: Colors.transparent,
                //阴影颜色
                // shadowColor: Colors.transparent,
                //标题边距
                titleSpacing: 8,
                //标题栏高度
                toolbarHeight: myAppTheme.appBarHeight,
                //title的样式
                titleTextStyle: const TextStyle(fontSize: 14, color: Colors.white),
                //actions图标样式，颜色，透明度，大小
                actionsIconTheme: const IconThemeData(color: Colors.white, opacity: 1.0, size: 16),
                //leading图标样式
                iconTheme: const IconThemeData(color: Colors.white, opacity: 1.0, size: 16),
              )
            : AppBarTheme(
                titleSpacing: 8,
                toolbarHeight: myAppTheme.appBarHeight,
              ),
      ),
      home: const SplashPage(),
    ));
  }
}
