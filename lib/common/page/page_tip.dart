import 'package:flutter/material.dart';

///错误提示界面
class TipPage extends StatelessWidget {

  const TipPage({Key? key, required this.title, required this.msg})
      : super(key: key);


  final String title;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(msg),
      ),
    );
  }
}
