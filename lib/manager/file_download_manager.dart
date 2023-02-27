/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:images/common/util/log_util.dart';
import 'package:path_provider/path_provider.dart';

import '../app.dart';

///create by itz on 2022/11/15 16:03
///desc :图片文件下载缓存器
class FileDownloadManager {
  FileDownloadManager._privateConstructor();

  static final FileDownloadManager _instance = FileDownloadManager._privateConstructor();

  static FileDownloadManager getInstance() {
    return _instance;
  }

  final Map<String, Downloader> _taskMap = {};

  ///添加一个下载任务
  void addTask(String url, String? name, DownloadCallback downloadCallback, {String? dirPath}) {
    Downloader downloader =
        _taskMap[url] ??= Downloader(url, name, this, dirPath ?? App.getConfigData().imageCachePath);
    downloader.setCallback(downloadCallback);
    downloader.start();
  }

  void remove(String url) {
    _taskMap.remove(url);
  }

  void removeCallback(String url, DownloadCallback downloadCallback) {
    _taskMap[url]?.removeCallback(downloadCallback);
  }

  ///下载的文件名称
  static String getFileName(String url, String? name) {
    //DESC:itz:2022/11/15 10:53:名称不能这么处理，如果链接包含特殊字符，
    // 文件就可能创建失败，就是这个名称不一定是一个正确的文件名
    String imageName = "${base64Url.encode(utf8.encode(url.split('/').last))}_NAME_$name";
    //操作系统限制路径的最大长度，这里限制名称不要超过128个字符，超过之后截取后128位。
    if (imageName.length > 128) {
      imageName = imageName.substring(imageName.length - 128, imageName.length);
    }
    return imageName;
  }

  ///下载的文件，如果文件夹不存在，这先创建文件夹
  ///[dirPath] 结尾需要分隔符
  static Future<File> checkOrCreateDirectory(String fileName, String dirPath) async {
    final folderDirectory = Directory(dirPath);
    if (!folderDirectory.existsSync()) await folderDirectory.create(recursive: true);
    final file = File(folderDirectory.path + fileName);
    return file;
  }
}

class Downloader {
  static const int STATUS_DILE = 0;

  ///下载中
  static const int STATUS_DOWNLOAD_ING = 1;

  ///下载暂停
  static const int STATUS_DOWNLOAD_PAUSE = 2;

  ///下载成功
  static const int STATUS_DOWNLOAD_SUCCESS = 3;

  ///下载失败
  static const int STATUS_DOWNLOAD_FAILED = 4;

  int status = STATUS_DILE;
  String url;
  String? name;
  FileDownloadManager? fileDownloadManager;
  String dir;

  Downloader(this.url, this.name, this.fileDownloadManager, this.dir);

  DownloadCallback? _downloadCallback;

  void setCallback(DownloadCallback callback) {
    _downloadCallback = callback;
  }

  void removeCallback(DownloadCallback callback) {
    if (_downloadCallback == callback) {
      _downloadCallback = null;
    }
  }

  ///开始
  void start() async {
    if (status == STATUS_DOWNLOAD_ING) {
      //正在下载，不处理
      _downloadCallback?.call(url, STATUS_DOWNLOAD_ING, null);
      return;
    }
    var fileName = FileDownloadManager.getFileName(url, name);
    final imgFile = await FileDownloadManager.checkOrCreateDirectory(fileName, dir);
    if (await imgFile.exists()) {
      //文件已经下载完成了
      //LogUtil.d("Downloader", "文件存在：${imgFile.path}");
      _callbackFinished(STATUS_DOWNLOAD_SUCCESS, imgFile.path);
      return;
    }

    //如果状态不是STATUS_DILE，则删除之前的文件，重新下载
    final downloadingFile = await FileDownloadManager.checkOrCreateDirectory("${fileName}_", dir);
    if (await downloadingFile.exists()) {
      await downloadingFile.delete();
    }
    //开始下载
    LogUtil.d("Downloader", "开始下载：$url");
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        if ((response.headers['content-type'] ?? "").startsWith('image')) {
          final file = File(downloadingFile.path);
          file.writeAsBytesSync(response.bodyBytes);
          await file.rename(imgFile.path);
          _callbackFinished(STATUS_DOWNLOAD_SUCCESS, imgFile.path);
        } else {
          _callbackFinished(STATUS_DOWNLOAD_FAILED, "-2");
        }
      } else {
        _callbackFinished(STATUS_DOWNLOAD_FAILED, response.statusCode.toString());
      }
    } catch (e) {
      _callbackFinished(STATUS_DOWNLOAD_FAILED, "-2");
    }
    LogUtil.d(
        "Downloader", "下载结束($status，success=${status == Downloader.STATUS_DOWNLOAD_SUCCESS})(${imgFile.path})：$url");
  }

  void _callbackFinished(int status, String data) {
    this.status = status;
    fileDownloadManager?.remove(url);
    var call = _downloadCallback;
    _downloadCallback = null;
    call?.call(url, status, data);
  }
}

///```
///[url] 下载的url
///[status] 下载状态 see[Downloader.status]
///[data] 当状态为[Downloader.STATUS_DOWNLOAD_SUCCESS]时，会返回文件路径地址.
///为[Downloader.STATUS_DOWNLOAD_FAILED]时：-1：url错误，url不包含图片。-2:请求异常。 其他code：response.statusCode，http状态码。
///```
typedef DownloadCallback = Function(String url, int status, String? data);
