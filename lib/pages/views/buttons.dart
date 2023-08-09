/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:flutter/material.dart';
import 'package:images/pages/views/desktop/win_titlebars.dart';

///create by itz on 2022/11/23 15:57
///desc :

///默认按钮样式，去除背景，圆角，阴影
///

class AButtonCommon {
  static final ButtonStyle STYLE_NORMAL = ButtonStyle(
    //去除最小size
    minimumSize: MaterialStateProperty.all(Size.zero),
    //去除padding
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    //背景颜色
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    //前景颜色
    shadowColor: MaterialStateProperty.all(Colors.transparent),
    //鼠标滑过的颜色
    overlayColor: MaterialStateProperty.all(Colors.black12),

    // foregroundColor: MaterialStateProperty.all(Colors.transparent),
    //  overlayColor: MaterialStateProperty.all(Colors.transparent),
    //  surfaceTintColor: MaterialStateProperty.all(Colors.transparent),

    //去除按钮周围的margin
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,

    //阴影
    elevation: MaterialStateProperty.all(0),
    //side: MaterialStateProperty.all(const BorderSide(width: 0)),
    //去除圆角
    //shape: MaterialStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.circular(0))),
  );

  ///[first]为主样式,[second]为辅样式，如果两个样式都为空，则返回空。
  static ButtonStyle? merge(ButtonStyle? first, ButtonStyle? second) {
    if (first == null && second == null) return null;
    if (first == null && second != null) return second;
    if (first != null && second == null) return first;
    return first?.merge(second);
  }
}

/// 去除圆角  shape:const  RoundedRectangleBorder(borderRadius: BorderRadius.zero)
class StyleButton extends ElevatedButton {
  StyleButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    ButtonStyle? style,
    required super.child,
  }) : super(style: AButtonCommon.merge(style, AButtonCommon.STYLE_NORMAL));

  ///appBar 里面的 icon 样式
  static ButtonStyle windowMenuButtonStyle({Size? size}) {
    return ElevatedButton.styleFrom(
      minimumSize: size ?? const Size(56, 40),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }

  ///文本按钮button样式
  static ButtonStyle textButtonStyle(
      {Color? backgroundColor, EdgeInsetsGeometry? padding, OutlinedBorder? shape, Alignment? alignment}) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        alignment: alignment ?? Alignment.center,
        padding: padding ?? const EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 8),
        shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }

  ///icon 按钮，圆角或圆形按钮.默认：padding=8,圆角=8
  static ButtonStyle buttonRectangle(
      {Color? backgroundColor, Size? minimumSize, EdgeInsetsGeometry? padding, BorderRadiusGeometry? borderRadius}) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        padding: padding ?? const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(8)));
  }

  ///如果要圆形，child 最好使用 [AspectRatio],设置宽高比为1.
  ///```
  ///StyleButton(
  ///     onPressed: () {},
  ///      style: StyleButton.iconButtonCircle(radius: 36),
  ///      child: AspectRatio(aspectRatio: 1,child: Icon(Icons.close)),
  ///)
  ///```
  static ButtonStyle iconButtonCircle(
      {Color? backgroundColor, Size? minimumSize, EdgeInsetsGeometry? padding, double? radius}) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: minimumSize??Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 120)));
  }


  ///dialog 确定按钮
  static ButtonStyle okButtonStyle(
      {Color? backgroundColor, EdgeInsetsGeometry? padding, OutlinedBorder? shape, Alignment? alignment}) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor?? Colors.blueAccent,
        alignment: alignment ?? Alignment.center,
        padding: padding ?? const EdgeInsets.all(14),
        shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }
  ///dialog 取消按钮
  static ButtonStyle cancelButtonStyle(
      {Color? backgroundColor, EdgeInsetsGeometry? padding, OutlinedBorder? shape, Alignment? alignment}) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor??Colors.black54,
        alignment: alignment ?? Alignment.center,
        padding: padding ?? const EdgeInsets.all(14),
        shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }
}

// class AButtonStyle extends ButtonStyle {
//   AButtonStyle({
//     TextStyle? textStyle,
//     Color? backgroundColor,
//     Color? foregroundColor,
//     Color? overlayColor,
//     Color? shadowColor,
//     Color? surfaceTintColor,
//     double? elevation,
//     EdgeInsetsGeometry? padding,
//     Size? minimumSize,
//     Size? fixedSize,
//     Size? maximumSize,
//     BorderSide? side,
//     OutlinedBorder? shape,
//     MouseCursor? mouseCursor,
//     super.visualDensity,
//     super.tapTargetSize,
//     super.animationDuration,
//     super.enableFeedback,
//     super.alignment,
//     super.splashFactory,
//   }) : super(
//           textStyle: textStyle == null ? null : MaterialStateProperty.all(textStyle),
//           backgroundColor: backgroundColor == null ? null : MaterialStateProperty.all(backgroundColor),
//           foregroundColor: foregroundColor == null ? null : MaterialStateProperty.all(foregroundColor),
//           overlayColor: overlayColor == null ? null : MaterialStateProperty.all(overlayColor),
//           shadowColor: shadowColor == null ? null : MaterialStateProperty.all(shadowColor),
//           surfaceTintColor: surfaceTintColor == null ? null : MaterialStateProperty.all(surfaceTintColor),
//           elevation: elevation == null ? null : MaterialStateProperty.all(elevation),
//           padding: padding == null ? null : MaterialStateProperty.all(padding),
//           minimumSize: minimumSize == null ? null : MaterialStateProperty.all(minimumSize),
//           fixedSize: fixedSize == null ? null : MaterialStateProperty.all(fixedSize),
//           maximumSize: maximumSize == null ? null : MaterialStateProperty.all(maximumSize),
//           side: side == null ? null : MaterialStateProperty.all(side),
//           shape: shape == null ? null : MaterialStateProperty.all(shape),
//           mouseCursor: mouseCursor == null ? null : MaterialStateProperty.all(mouseCursor),
//         );
// }
