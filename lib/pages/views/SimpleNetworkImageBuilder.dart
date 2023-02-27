/*年轻人，只管向前看，不要管自暴自弃者的话*/

///create by itz on 2022/11/15 10:44
import 'dart:io';

import 'package:flutter/material.dart';
import '../../manager/file_download_manager.dart';

class SimpleNetworkImageBuilder extends StatefulWidget {
  const SimpleNetworkImageBuilder(
      {Key? key,
      required this.name,
      required this.url,
      this.placeHolder,
      this.errorWidget,
      required this.builder,
      this.dirPath})
      : super(key: key);

  ///如果name有后缀，这这个文件就有后缀，否则就是没有。
  final String name;
  final String? dirPath;
  final String url;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final Widget Function(File image) builder;

  @override
  State<SimpleNetworkImageBuilder> createState() => _SimpleNetworkImageBuilderState();
}

class _SimpleNetworkImageBuilderState extends State<SimpleNetworkImageBuilder> {
  String? _loadData;
  int _loadStatus = Downloader.STATUS_DILE;
  DownloadCallback? _callback;

  @override
  void initState() {
    super.initState();
    _callback = (url, status, data) {
      if (status == Downloader.STATUS_DOWNLOAD_SUCCESS || status == Downloader.STATUS_DOWNLOAD_FAILED) {
        setState(() {
          _loadStatus = status;
          _loadData = data;
        });
      }
    };
    FileDownloadManager.getInstance().addTask(widget.url, widget.name, _callback!, dirPath: widget.dirPath);
  }

  @override
  void dispose() {
    FileDownloadManager.getInstance().removeCallback(widget.url, _callback!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadStatus == Downloader.STATUS_DILE || _loadStatus == Downloader.STATUS_DOWNLOAD_ING) {
      return widget.placeHolder ?? const Center(child: CircularProgressIndicator());
    }
    if (_loadStatus == Downloader.STATUS_DOWNLOAD_SUCCESS && _loadData != null) {
      return widget.builder(File(_loadData!));
    }
    var error = "加载错误：";
    if (_loadData == "-1") {
      error += "url资源非图片资源";
    } else if (_loadData == "-2") {
      error += "请检查网络";
    } else {
      error += "网络错误($_loadData)";
    }
    return widget.errorWidget ?? Center(child: Text(error));
  }
}
