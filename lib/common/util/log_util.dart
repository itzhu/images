import 'dart:math';

///不同的操作系统或者编译器，log输出颜色可能会有差异。
/// AndroidStudio  左下角run窗口输出log可以看到不同颜色
class LogUtil {

  static var openLog = true;

  static const int VERBOSE = 2;
  static const int DEBUG = 3;
  static const int INFO = 4;
  static const int WARN = 5;
  static const int ERROR = 6;

  static const int _SIZE_SEGMENT = 1024 * 2;

  ///是否显示当前的时间
  static const _showTime = true;
  static const _showColor = true;

  static void v(String tag, String msg) {
    _printLog(VERBOSE, tag, msg);
  }

  static void d(String tag, String msg) {
    _printLog(DEBUG, tag, msg);
  }

  static void i(String tag, String msg) {
    _printLog(INFO, tag, msg);
  }

  static void w(String tag, String msg) {
    _printLog(WARN, tag, msg);
  }

  static void e(String tag, String msg) {
    _printLog(ERROR, tag, msg);
  }

  static void _printLog(int level, String tag, String msg) {
    if(!openLog)return;
    var time = _showTime ? formatDate(DateTime.now()) : "";
    var levelStr = _getLevelColor(level);
    var endColor = _showColor ? _clearColor : '';
    var content = "$time|  $tag:$msg";

    var length = content.length;
    if (length <= _SIZE_SEGMENT) {
      // 长度小于等于限制直接打印
      print("$levelStr |$content| $endColor");
    } else {
      var printLength = 0;
      while (printLength < length) {
        // 循环分段打印日志
        var end = min(printLength + _SIZE_SEGMENT, length);
        var logContent = content.substring(printLength, end);
        printLength = end;
        print("$levelStr | $logContent | $endColor");
      }
    }
    _log2File("log-flt-$level " + content);
  }

  static void _log2File(String text) {
    //TODO:itz:2022/3/28 18:04:
  }

  ///打印结束要清除颜色设置，不清除会导致后面的log输出颜色也发生变化
  static const String _clearColor = '\u001b[0m ';

  ///参考：https://blog.csdn.net/Soinice/article/details/97052030
  ///参考：https://blog.csdn.net/ShewMi/article/details/78992458
  ///文字颜色(30黑色) (31红色) (32绿色) (33黄色) (34蓝色) (35紫色) (36浅蓝) (37灰色)。加背景的话可能会导致颜色与上面不一致
  ///40-47 背景颜色：和颜色顺序相同
  ///90-97 颜色2：比颜色1更鲜艳一些
  static String _getLevelColor(int level) {
    switch (level) {
      case VERBOSE:
        return 'v ${_showColor ? '\u001b[35m' : ''}';
      case DEBUG:
        //42 是前景颜色
        return 'd ${_showColor ? '\u001b[40;38m' : ''}';
      case INFO:
        return 'i ${_showColor ? '\u001b[32m' : ''}';
      case WARN:
        return 'w ${_showColor ? '\u001b[33m' : ''}';
      case ERROR:
        return 'e ${_showColor ? '\u001b[31m' : ''}';
    }
    return '';
  }

  static String formatDate(DateTime date) {
    String strDate =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}:${date.millisecond.toString().padLeft(3, '0')}";
    return strDate;
  }
}
