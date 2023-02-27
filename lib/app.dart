import 'dart:io';

import 'package:images/common/http/http_client.dart';
import 'package:images/routes/routes.dart';
import 'package:fluro/fluro.dart';

import 'app_const.dart';

class App {
  App._privateConstructor();

  static final App _instance = App._privateConstructor();

  static App getInstance() {
    return _instance;
  }

  static FluroRouter? _router;
  static HttpManager? _httpManager;
  static AppConfig? _configData;
  static bool _desktopPlatform = false;
  static bool _mobilePlatform = false;

  ///程序运行的初始化操作，可能是耗时操作。
  Future<bool> init() async {
    //初始化路由
    _router ??= Routes.create();
    _configData = AppConfig();
    await _configData!.init();
    _desktopPlatform = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
    _mobilePlatform = Platform.isAndroid || Platform.isIOS;
    return Future.value(true);
  }

  static FluroRouter getRouter() {
    // _router ??= Routes.create();
    return _router!;
  }

  static HttpManager getHttpManager() {
    _httpManager ??= HttpManager();
    return _httpManager!;
  }

  static AppConfig getConfigData() {
    return _configData!;
  }

  static bool isDeskTopPlatfrom() {
    return _desktopPlatform;
  }

  static bool isMobilePlatform() {
    return _mobilePlatform;
  }
}
