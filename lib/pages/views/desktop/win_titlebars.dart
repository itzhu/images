/*摆脱冷气，只是向上走，不必听自暴自弃者流的话。*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:images/main.dart';
import 'package:window_manager/window_manager.dart';

///@name  : win_page_home
///@author: create by  itzhu |  2022/6/2
///@desc  : 主页，桌面平台使用

///desktop button的宽度，库里面定义的大小，为了保持一致，一般的图片按钮大小都用这个尺寸
///详情看[WindowCaptionButton] 里面定义的   constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
const double WIDTH_WIN_BT = 46;
const double HEIGHT_WIN_BAR = 32;

///隐藏，全屏-窗口，关闭按钮
class WindowButtons extends StatefulWidget {
  ///[brightness] [Brightness.dark]则菜单按钮为白色，[Brightness.light]为黑色
  const WindowButtons({Key? key, this.title, this.backgroundColor, this.brightness, this.showDragToMoveArea = false})
      : super(key: key);

  final Color? backgroundColor;
  final Brightness? brightness;
  final bool showDragToMoveArea;
  final Widget? title;

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: myAppTheme.appBarHeight,
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          !widget.showDragToMoveArea
              ? const Spacer()
              : Expanded(
                  child: DragToMoveArea(
                    child: SizedBox(
                      height: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: widget.brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.8956)
                                    : Colors.white,
                                fontSize: 14,
                              ),
                              child: widget.title ?? Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          WindowCaptionButton.minimize(
            brightness: widget.brightness,
            onPressed: () async {
              bool isMinimized = await windowManager.isMinimized();
              if (isMinimized) {
                windowManager.restore();
              } else {
                windowManager.minimize();
              }
            },
          ),
          FutureBuilder<bool>(
            future: windowManager.isMaximized(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return WindowCaptionButton.unmaximize(
                  brightness: widget.brightness,
                  onPressed: () {
                    windowManager.unmaximize();
                  },
                );
              }
              return WindowCaptionButton.maximize(
                brightness: widget.brightness,
                onPressed: () {
                  windowManager.maximize();
                },
              );
            },
          ),
          WindowCaptionButton.close(
            brightness: widget.brightness,
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}

///拖拽移动窗口
class WinDragMoveView extends StatelessWidget {
  const WinDragMoveView({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
        child: SizedBox(
      height: myAppTheme.appBarHeight,
      // color: const Color(0xccffff00),
      child: child,
    ));
  }
}

///桌面平台占位使用：- [] X 右边三个按钮的空间，不能被遮挡。
class WinMenuEmptyView extends StatelessWidget {
  const WinMenuEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? (WIDTH_WIN_BT * 3) : 0,
    );
  }
}

class WAppBar extends AppBar {
  ///如果修改[flexibleSpace],则标题栏会失去移动窗口的能力
  WAppBar({
    super.key,
    super.leading,
    super.automaticallyImplyLeading = true,
    super.title,
    super.actions,
    super.flexibleSpace = const WinDragMoveView(),
    super.bottom,
    super.elevation = 0,
    super.scrolledUnderElevation,
    super.notificationPredicate = defaultScrollNotificationPredicate,
    super.shadowColor,
    super.surfaceTintColor,
    super.shape,
    super.backgroundColor,
    super.foregroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary = true,
    super.centerTitle,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.toolbarOpacity = 1.0,
    super.bottomOpacity = 1.0,
    super.toolbarHeight,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
  }) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      actions?.add(const WinMenuEmptyView());
    }
  }
}

class WindowMenus extends StatefulWidget {
  ///[brightness] [Brightness.dark]则菜单按钮为白色，[Brightness.light]为黑色
  const WindowMenus({Key? key, this.title, this.backgroundColor, this.brightness}) : super(key: key);

  final Color? backgroundColor;
  final Brightness? brightness;
  final Widget? title;

  @override
  State<WindowMenus> createState() => _WindowMenusState();
}

class _WindowMenusState extends State<WindowMenus> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      height: myAppTheme.appBarHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WindowCaptionButton.minimize(
            brightness: widget.brightness,
            onPressed: () async {
              bool isMinimized = await windowManager.isMinimized();
              if (isMinimized) {
                windowManager.restore();
              } else {
                windowManager.minimize();
              }
            },
          ),
          FutureBuilder<bool>(
            future: windowManager.isMaximized(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return WindowCaptionButton.unmaximize(
                  brightness: widget.brightness,
                  onPressed: () {
                    windowManager.unmaximize();
                  },
                );
              }
              return WindowCaptionButton.maximize(
                brightness: widget.brightness,
                onPressed: () {
                  windowManager.maximize();
                },
              );
            },
          ),
          WindowCaptionButton.close(
            brightness: widget.brightness,
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
