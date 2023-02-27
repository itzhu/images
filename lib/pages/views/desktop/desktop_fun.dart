/*年轻人，只管向前看，不要管自暴自弃者的话*/
import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

///create by itz on 2022/11/17 11:07
///desc :
class DesktopFun {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      //不显示在任务栏
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      //去除窗口边框,不可调整大小
     // await windowManager.setAsFrameless();

      await windowManager.show();
      await windowManager.focus();
    });
    return Future.value();
  }
}
