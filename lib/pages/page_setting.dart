/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:images/app.dart';
import 'package:images/common/util/log_util.dart';
import 'package:images/main.dart';
import 'package:images/pages/views/desktop/win_titlebars.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '../app_const.dart';
import '../r.dart';
import 'views/buttons.dart';

///create by itz on 2022/11/17 14:17
///desc :

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String _TAG = "SettingsPage";
  final List<_MenuInfo> _menuInfoList = [];
  StateSetter? _setState;
  _MenuInfo? _selectMenu;

  @override
  void initState() {
    _menuInfoList.add(_MenuInfo(0, "主题&背景", GlobalKey()));
    _menuInfoList.add(_MenuInfo(1, "缓存&下载", GlobalKey()));
    _selectMenu = _menuInfoList[0];
    _selectMenu?.setSelect(true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        title: const Text("设置"),
      ),
      body: ChangeNotifierProvider.value(
          value: App.getConfigData(),
          builder: (context, child) {
            return Stack(
              children: [
                Row(
                  children: [
                    //菜单锚点
                    Flexible(flex: 1, child: _menuView(context)),
                    //设置项
                    Flexible(
                      flex: 2,
                      child: _page(),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget _menuView(BuildContext context) {
    return Container(
        color: myAppTheme.primarySwatch,
        child: EasyRefresh(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: _menuInfoList[index],
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SizedBox(
                            width: double.maxFinite,
                            child: StyleButton(
                              style: StyleButton.textButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 36, top: 24, bottom: 24)),
                              onPressed: () {
                                if (_selectMenu?.id != _menuInfoList[index].id) {
                                  _selectMenu?.setSelect(false);
                                  _selectMenu = _menuInfoList[index];
                                  _selectMenu?.setSelect(true);
                                  _setState?.call(() {});
                                }
                              },
                              child: Text(
                                _menuInfoList[index].text,
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                        Container(
                          width: 8,
                          height: 24,
                          color: context.watch<_MenuInfo>().select ? const Color(0xDDF4511E) : Colors.transparent,
                        )
                      ],
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 0, color: Colors.transparent);
              },
              itemCount: _menuInfoList.length),
        ));
  }

  Widget _page() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        _setState = setState;
        var id = _selectMenu?.id ?? 0;
        switch (id) {
          case 0:
            return const _BgSetView();
          case 1:
            return const _PathSetView();
        }
        return const _BgSetView();
      },
    );
  }
}

class _MenuInfo extends ChangeNotifier {
  int id;
  String text;
  GlobalKey anchorItemKey;
  bool _select = false;

  _MenuInfo(this.id, this.text, this.anchorItemKey);

  bool get select => _select;

  void setSelect(bool select) {
    _select = select;
    notifyListeners();
  }
}

///右边界面通用设计，标题和组件
class _BaseSetPageWidget extends StatelessWidget {
  const _BaseSetPageWidget({Key? key, required this.title, required this.child}) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Container(
          color: Colors.black12,
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 30),
                  )),
              Expanded(child: EasyRefresh(child: child)),
            ],
          ),
        ));
  }
}

///主题背景设置
class _BgSetView extends StatelessWidget {
  const _BgSetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> bgList = [
      R.assetsImgBgBg1,
      R.assetsImgBgBg2,
      R.assetsImgBgBg3,
      R.assetsImgBgBg4,
      R.assetsImgBgBg5,
    ];

    List<Color> defaultColor = const [
      //1
      Color(0xFFFF8C00),
      Color(0xFFE81123),
      Color(0xFFD13438),
      Color(0xFFC30052),
      Color(0xFFBF0077),
      Color(0xFF9A0089),
      Color(0xFF881798),
      Color(0xFF744DA9),

      //2
      Color(0xFF10893E),
      Color(0xFF107C10),
      Color(0xFF018574),
      Color(0xFF2D7D9A),
      Color(0xFF0063B1),
      Color(0xFF6B69D6),
      Color(0xFF8E8CD8),
      Color(0xFF8764B8),

      //3
      Color(0xFF038387),
      Color(0xFF486860),
      Color(0xFF525E54),
      Color(0xFF7E735F),
      Color(0xFF4C4A48),
      Color(0xFF515C6B),
      Color(0xFF4A5459),
      Color(0xFF000000),
    ];

    return _BaseSetPageWidget(
      title: "主题&背景",
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text("背景图片", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Wrap(
                children: List.generate(bgList.length, (index) {
              return InkWell(
                hoverColor: Colors.white70,
                onTap: () {
                  context.read<AppConfig>().setSoftBackground(bgList[index]);
                },
                child: Container(
                  width: 128,
                  height: 128,
                  margin: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Image.asset(bgList[index], width: double.maxFinite, height: double.maxFinite, fit: BoxFit.cover),
                      Visibility(
                        visible: context.select((AppConfig config) => config.softBackground) == bgList[index],
                        child: const Icon(
                          Icons.check,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })),
            const SizedBox(height: 20),
            const Text("前景色&模糊", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                var appConfig = context.read<AppConfig>();
                appConfig.setSoftBackgroundBlur(!appConfig.softBackgroundBlur);
              },
              child: Container(
                color: Colors.white38,
                height: 64,
                child: Row(children: [
                  Icon(context.watch<AppConfig>().softBackgroundBlur
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank_sharp),
                  const SizedBox(width: 16),
                  Text(
                    context.watch<AppConfig>().softBackgroundBlur ? "开" : "关",
                    style: const TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ),
            Visibility(
                visible: context.watch<AppConfig>().softBackgroundBlur,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text("透明度", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.white38,
                      height: 64,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            alignment: Alignment.center,
                            child:
                                Text((context.watch<AppConfig>().softBackgroundColorOpacity * 100).toStringAsFixed(0)),
                          ),
                          Expanded(
                              child: Slider(
                                  value: context.read<AppConfig>().softBackgroundColorOpacity * 100,
                                  min: 0,
                                  max: 100,
                                  onChanged: (value) {
                                    context.read<AppConfig>().setSoftBackgroundBlurOpacity(value / 100);
                                  }))
                        ],
                      ),
                    ),
                    const Text("模糊度", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.white38,
                      height: 64,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            alignment: Alignment.center,
                            child: Text(context.watch<AppConfig>().blurSigma.toStringAsFixed(0)),
                          ),
                          Expanded(
                              child: Slider(
                                  value: context.read<AppConfig>().blurSigma,
                                  min: 0,
                                  max: 30,
                                  onChanged: (value) {
                                    context.read<AppConfig>().setBlurSigma(value);
                                  }))
                        ],
                      ),
                    ),
                    const Text("前景色", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.maxFinite,
                      color: Colors.white38,
                      child: Wrap(
                        children: List.generate(defaultColor.length + 1, (index) {
                          if (index == 0) {
                            return Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.topLeft,
                              color: Color(context.select((AppConfig value) => value.softBackgroundColor)),
                              child: const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              App.getConfigData().setSoftBackgroundColor(defaultColor[index - 1].value);
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.all(4),
                              color: defaultColor[index - 1],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                        onTap: () {
                          _showColorPicker(context, Color(context.read<AppConfig>().softBackgroundColor));
                        },
                        child: Container(
                          color: Colors.white38,
                          height: 64,
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                color: Colors.white24,
                                margin: const EdgeInsets.all(6),
                                child: const Icon(Icons.add),
                              ),
                              const Text("自定义颜色")
                            ],
                          ),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Color selectColor) {
    var pickColor = selectColor;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("自定义颜色"),
              actions: [
                StyleButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: StyleButton.cancelButtonStyle(),
                    child: const Text("取消")),
                StyleButton(
                    onPressed: () {
                      App.getConfigData().setSoftBackgroundColor(pickColor.value);
                      Navigator.pop(context);
                    },
                    style: StyleButton.okButtonStyle(),
                    child: const Text("确定"))
              ],
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectColor,
                  onColorChanged: (color) {
                    pickColor = color;
                  },
                ),
              ));
        });
  }
}

class _PathSetView extends StatefulWidget {
  const _PathSetView({Key? key}) : super(key: key);

  @override
  State<_PathSetView> createState() => _PathSetViewState();
}

class _PathSetViewState extends State<_PathSetView> {
  final int TYPE_CACHE = 0;
  final int TYPE_DOWNLOAD = 1;

  @override
  Widget build(BuildContext context) {
    return _BaseSetPageWidget(
        title: "缓存&下载",
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text("图片缓存路径", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Container(
                  width: double.maxFinite,
                  color: Colors.white38,
                  height: 64,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(context.select((AppConfig config) => config.imageCachePath))),
              Container(
                color: Colors.white38,
                child: Row(
                  children: [
                    StyleButton(
                        onPressed: () {},
                        style: StyleButton.textButtonStyle(),
                        child: const Text(
                          "打开文件夹",
                        )),
                    StyleButton(
                      onPressed: () {
                        _pickFile(path: App.getConfigData().imageCachePath, type: TYPE_CACHE);
                      },
                      style: StyleButton.textButtonStyle(),
                      child: const Text(
                        "重新选择",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("图片下载路径", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Container(
                  width: double.maxFinite,
                  color: Colors.white38,
                  height: 64,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(context.select((AppConfig config) => config.imageDownloadPath))),
              Container(
                color: Colors.white38,
                child: Row(
                  children: [
                    StyleButton(
                        onPressed: () {},
                        style: StyleButton.textButtonStyle(),
                        child: const Text(
                          "打开文件夹",
                        )),
                    StyleButton(
                      onPressed: () {
                        _pickFile(path: App.getConfigData().imageDownloadPath, type: TYPE_DOWNLOAD);
                      },
                      style: StyleButton.textButtonStyle(),
                      child: const Text(
                        "重新选择",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _openFile() {}

  void _pickFile({required String path, required int type}) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle:"选择文件夹",initialDirectory: path);
    LogUtil.d("pick file path:", "type:$type>>>$selectedDirectory");
    if (selectedDirectory == null) return;
    if (type == TYPE_CACHE) {
      if (selectedDirectory == App.getConfigData().imageCachePath) return;
      _showPathChangeDialog(
          title: "提示",
          msg: "将图片缓存路径修改为：\n $selectedDirectory",
          callback: (action) {
            if (AppCode.ACTION_OK == action) {
              App.getConfigData().saveImageCachePath(selectedDirectory);
              toast("路径修改成功");
            }
          });
    } else if (type == TYPE_DOWNLOAD) {
      if (selectedDirectory == App.getConfigData().imageDownloadPath) return;
      _showPathChangeDialog(
          title: "提示",
          msg: "将图片下载路径修改为：\n $selectedDirectory",
          callback: (action) {
            if (AppCode.ACTION_OK == action) {
              App.getConfigData().saveImageDownloadPath(selectedDirectory);
              toast("路径修改成功");
            }
          });
    }
  }

  void _showPathChangeDialog({required String title, required String msg, Function(int action)? callback}) {
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              StyleButton(
                  onPressed: () {
                    callback?.call(AppCode.ACTION_CANCEL);
                    Navigator.pop(context);
                  },
                  style: StyleButton.cancelButtonStyle(),
                  child: const Text("取消")),
              StyleButton(
                  onPressed: () {
                    callback?.call(AppCode.ACTION_OK);
                    Navigator.pop(context);
                  },
                  style: StyleButton.okButtonStyle(),
                  child: const Text("确定"))
            ],
          );
        });
  }
}
