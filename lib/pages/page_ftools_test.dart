/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:flutter/material.dart';
//import 'package:ftools/ftools_platform_interface.dart';
import 'package:images/common/util/log_util.dart';
import 'package:images/pages/views/buttons.dart';
import 'package:images/pages/views/desktop/win_titlebars.dart';

///create by itz on 2022/11/24 18:18
///desc :

class FtoolsTestPage extends StatefulWidget {
  const FtoolsTestPage({Key? key}) : super(key: key);

  @override
  State<FtoolsTestPage> createState() => _FtoolsTestPageState();
}

class _FtoolsTestPageState extends State<FtoolsTestPage> {
  String? _version;
  String _text="";

  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(title: const Text("Ftools 测试")),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Wrap(
            children: [
              _Button(onPressed: () {}, child: Text("版本：${_version}")),
              const SizedBox(width: 3),
              _Button(
                  onPressed: () {
                    openUrl("https://www.baidu.com");
                  },
                  child: Text("打开百度")),
              const SizedBox(width: 3),
              _Button(
                  onPressed: () {
                    openUrl("c:\\");
                  },
                  child: Text("打开C盘")),
              const SizedBox(width: 3),
              _Button(
                  onPressed: () {
                    openFile("A:\\runner_log.log", app: "notepad");
                  },
                  child: Text("打开文件"))
            ],
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: Text("请输入cmd指令", style: TextStyle(color: Colors.blue, fontSize: 20)),
                hintText: "flutter doctor \\ ipconfig \\...",
                fillColor: Color(0x30cccccc),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF000000)),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              maxLines: 10,
              toolbarOptions: const ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
              onChanged: (text){
                _text = text;
              },
            ),
          ),
          _Button(onPressed: (){
            cmd(_text);
          }, child: Text("开始执行")),
        ],
      ),
    );
  }

  Widget _Button({required VoidCallback onPressed, required Widget child}) {
    return StyleButton(
        onPressed: onPressed,
        style: StyleButton.buttonRectangle(padding: const EdgeInsets.all(12), backgroundColor: Colors.blue),
        child: child);
  }

  void _getVersion() async {
    // _version = await FtoolsPlatform.instance.getPlatformVersion();
    // setState(() {});
  }

  void openUrl(String url, {String app = ""}) async {
    // int? code = await FtoolsPlatform.instance.execSystem("start $app $url");
    // LogUtil.d("open url", " code : $code");
  }

  void openDirectory(String dirPath, {String app = ""}) async {
    // int? code = await FtoolsPlatform.instance.execSystem("start $app $dirPath");
    // LogUtil.d("open url", " code : $code");
  }

  void openFile(String filePath, {String app = ""}) async {
    // int? code = await FtoolsPlatform.instance.execSystem("start $app $filePath");
    // LogUtil.d("cmd", " cmd : $code");
  }

  Future<void> cmd(String cmd) async {
    // int? code = await FtoolsPlatform.instance.execSystem(cmd);
    // LogUtil.d("cmd", " cmd : $code");
  }
}
