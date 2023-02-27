/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images/app_const.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import 'views/desktop/win_titlebars.dart';

///create by itz on 2022/11/14 13:44
///desc : 主界面

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _windowPlatform = false;
  GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    //标题栏
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _windowPlatform = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: App.getConfigData(),
        builder: (context, child) {
          //背景图片
          return WillPopScope(
              child: Scaffold(
                body: Stack(
                  children: [
                    //背景
                    SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child:
                          Image.asset(context.select((AppConfig config) => config.softBackground), fit: BoxFit.cover),
                    ),

                    //模糊效果
                    Visibility(
                        visible: context.select((AppConfig config) => config.softBackgroundBlur),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: context.select((AppConfig config) => config.blurSigma),
                            sigmaY: context.select((AppConfig config) => config.blurSigma),
                          ),
                          child: Opacity(
                            opacity: context.select((AppConfig config) => config.softBackgroundColorOpacity),
                            child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Color(context.select((AppConfig config) => config.softBackgroundColor))),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text("create by itz.仅用于学习交流.", style: Theme.of(context).textTheme.bodySmall),
                              ),
                            ),
                          ),
                        )),

                    //子页面
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Navigator(
                        key: _homeNavigatorKey,
                        onGenerateRoute: App.getRouter().generator,
                      ),
                    ),

                    //desktop 顶部的拖动和3个按钮
                    _windowPlatform
                        ? Row(children: const [
                            Expanded(child: WinDragMoveView()),
                            WindowMenus(brightness: Brightness.dark)
                          ])
                        : Container(),
                  ],
                ),
              ),
              onWillPop: () {
                return _onBackPressed(context);
              });
        });
  }

  Future<bool> _onBackPressed(BuildContext context) {
    //这里是回调函数
    if (_homeNavigatorKey.currentState?.canPop() == true) {
      _homeNavigatorKey.currentState?.pop(context);
    } else {
      SystemNavigator.pop();
    }
    return Future.value(false);
  }
}
