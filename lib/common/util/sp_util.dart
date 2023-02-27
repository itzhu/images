import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/util/log_util.dart';

/// that is used to save data to the SharedPreferences.
class SpUtil {
  ///return a `Future<SharedPreferences>` object
  static Future<SharedPreferences> getSp() {
    //C:\Users\Administrator\AppData\Roaming\com.example\joyingme
    return SharedPreferences.getInstance();
  }

  /// [value] 类型可以为 int、double、String、bool、List<String>
  static Future<bool> put<T>(String key, dynamic value) async {
    SharedPreferences prefs = await getSp();
    var ret = false;
    try {
      if (value is int) {
        ret = await prefs.setInt(key, value);
      } else if (value is double) {
        ret = await prefs.setDouble(key, value);
      } else if (value is String) {
        ret = await prefs.setString(key, value);
      } else if (value is bool) {
        ret = await prefs.setBool(key, value);
      } else if (value is List<String>) {
        ret = await prefs.setStringList(key, value);
      }
    } catch (e) {
      LogUtil.e("SpUtil", "put error:$e");
    }
    return ret;
  }

  /// If the value of the key is not null, return the value of the key, otherwise return the default value
  ///
  /// [defaultValue] (T): The default value of the key.
  /// 只有数据为null或读取失败，才返回defaultValue。
  ///
  /// T 类型可以为 int、double、String、bool、List<String>
  static Future<T> get<T>(String key, T defaultValue) async {
    SharedPreferences prefs = await getSp();
    dynamic value;
    try {
      if (defaultValue is int) {
        value = prefs.getInt(key);
      } else if (defaultValue is double) {
        value = prefs.getDouble(key);
      } else if (defaultValue is String) {
        value = prefs.getString(key);
      } else if (defaultValue is bool) {
        value = prefs.getBool(key);
      } else if (defaultValue is List<String>) {
        value = prefs.getStringList(key);
      }
    } catch (e) {
      LogUtil.e("SpUtil", "get error:$e");
    }
    value ??= defaultValue;
    return Future.value(value);
  }

  static Future<bool> clearAll() async {
    var sp = await getSp();
    return sp.clear();
  }
}
