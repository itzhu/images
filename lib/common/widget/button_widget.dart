import 'package:flutter/material.dart';

///可配置控件点击事件
///
///控件被touch时，alpha，scale变化。默认按下时scale=0.95  alpha=0.8
///
///点击事件：onPressed
///
///双击事件：onDoubleTap
class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    Key? key,
    this.scaleX = 0.95,
    this.scaleY = 0.95,
    this.alpha = 0.8,
    this.child,
    this.onPressed,
    this.onDoubleTap,
  }) : super(key: key);

  ///x轴缩放
  final double scaleX;

  ///y轴缩放
  final double scaleY;

  ///按下时的透明度
  final double alpha;

  final Widget? child;

  final GestureTapCallback? onPressed;
  final GestureTapCallback? onDoubleTap;

  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  var _actionDown = false;

  void changeDown(bool pressed) {
    _actionDown = pressed;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var scaleX = _actionDown ? widget.scaleX : 1.0;
    var scaleY = _actionDown ? widget.scaleY : 1.0;
    var alpha = _actionDown ? widget.alpha : 1.0;
    return GestureDetector(
      //touch事件
      onTapDown: (details) {
        changeDown(true);
      },
      onTapUp: (details) {
        changeDown(false);
      },
      onTapCancel: () {
        changeDown(false);
      },
      onTap: widget.onPressed,
      onDoubleTap: widget.onDoubleTap,
      child: Opacity(
        //透明度
        opacity: alpha,
        child: Transform(
          transform: Matrix4.identity()..scale(scaleX, scaleY),
          //居中缩放
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
