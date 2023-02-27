import 'dart:async';

import 'package:flutter/cupertino.dart';

class KeyboardContent extends StatefulWidget {
  ///键盘弹出时间
  final int animTime;

  ///键盘高度变化后，视图的延迟变化时间。因为某些手机键盘切换时，会先隐藏再显示，如果不延时，会造成界面跳动或闪屏。
  final int delayTime;

  const KeyboardContent({Key? key, this.animTime = 300, this.delayTime = 100}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeyboardContentState();
}

class _KeyboardContentState extends State<KeyboardContent> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  var _keyboardHeight = 0.0;
  var _currentHeight = 0.0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      _refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _currentHeight,
      duration: Duration(milliseconds: widget.animTime),
    );
  }

  void _refresh() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer(Duration(milliseconds: widget.delayTime), () {
      _timer = null;
      setState(() {
        _currentHeight = _keyboardHeight;
      });
    });
  }
}
