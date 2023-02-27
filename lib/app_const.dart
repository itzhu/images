/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:images/r.dart';
import 'package:path_provider/path_provider.dart';

///create by itz on 2022/11/21 19:04
///desc :

class AppConst {
  static const String DIR_CACHE_NAME = "cached_img";
  static const String DIR_DOWNLOAD_IMAGE_NAME = "download_img";
}

class AppCode {
  static const REQUEST_SUCCESS = 10000;
  static const REQUEST_ERROR_DATA = 10001;
  static const REQUEST_CANCEL = 10002;
  static const REQUEST_ERROR_PARAMS = 10003;

  static const ACTION_CANCEL = 0;
  static const ACTION_OK = 1;
}

class AppKey {
  static const MC_IndexData = "IndexData";
  static const MC_ConfigData = "ConfigData";
}

///app的配置信息
class AppConfig extends ChangeNotifier {
  ///图片缓存地址
  String imageCachePath = "";

  ///图片存放地址
  String imageDownloadPath = "";

  //UI参数--------------------------------------------------
  ///软件背景
  String softBackground = "";

  ///软件背景显示模糊效果
  bool softBackgroundBlur = true;

  ///软件背景模糊程度0-20
  double blurSigma = 8.0;

  ///软件背景色
  int softBackgroundColor = Colors.white.value;

  ///软件背景色显示透明度
  double softBackgroundColorOpacity = 0.6;

  //--------------------------------------------------

  Future<void> init() async {
    var rootDir = await getApplicationDocumentsDirectory();
    imageCachePath = '${rootDir.path}/${AppConst.DIR_CACHE_NAME}/';
    imageDownloadPath = '${rootDir.path}/${AppConst.DIR_DOWNLOAD_IMAGE_NAME}/';
    softBackground = R.assetsImgBgBg1;
    softBackgroundBlur = true;
  }

  void setSoftBackground(String value) {
    softBackground = value;
    notifyListeners();
  }

  void setSoftBackgroundBlur(bool value) {
    softBackgroundBlur = value;
    notifyListeners();
  }

  void setSoftBackgroundBlurOpacity(double value) {
    softBackgroundColorOpacity = value;
    notifyListeners();
  }

  void setBlurSigma(double value) {
    blurSigma = value;
    notifyListeners();
  }

  void setSoftBackgroundColor(int value) {
    softBackgroundColor = value;
    notifyListeners();
  }

  void saveImageCachePath(String path) {
    imageCachePath = path;
    notifyListeners();
  }

  void saveImageDownloadPath(String path) {
    imageDownloadPath = path;
    notifyListeners();
  }

  void _saveConfig(String key, String? value) {

  }
}
