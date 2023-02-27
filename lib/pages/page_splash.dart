/*摆脱冷气，只是向上走，不必听自暴自弃者流的话。*/

import 'package:flutter/material.dart';
import 'package:images/app_const.dart';
import 'package:images/common/util/log_util.dart';

import '../../app.dart';
import 'page_main.dart';

///@name  : page_splash
///@author: create by  itzhu |  2022/6/9
///@desc  : 闪屏界面,进行初始化操作
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const _TAG = "SplashPage";

  @override
  Widget build(BuildContext context) {
    _init().then((value) {
      _goToMain(context);
    });
    return const Scaffold(
      backgroundColor: Colors.white60,
      body: Center(child: Text("Welcome ...")),
    );
  }

  Future<void> _init() async {
    await App.getInstance().init();
  }

  void _goToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        return const MainPage();
      }),
      (route) => false,
    );
  }
}
