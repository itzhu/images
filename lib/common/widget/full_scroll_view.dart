/*摆脱冷气，只是向上走，不必听自暴自弃者流的话。*/

import 'package:flutter/material.dart';

///@name  : full_scroll_view
///@author: create by  itzhu |  2022/5/17
///@desc  :
class FullScrollView extends StatelessWidget {
  final Widget child;
  final double? minWidth;

  const FullScrollView({Key? key, required this.child, this.minWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth ?? double.infinity, minHeight: constraints.maxHeight),
          child: child,
        ),
      );
    });
  }
}
