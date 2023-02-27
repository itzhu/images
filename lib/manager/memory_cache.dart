/*年轻人，只管向前看，不要管自暴自弃者的话*/

///create by itz on 2022/11/21 9:12
///desc :
class MemoryCache {
  MemoryCache._privateConstructor();

  static final MemoryCache _instance = MemoryCache._privateConstructor();

  static MemoryCache getInstance() {
    return _instance;
  }

 final Map<String, dynamic> _dataMap = {};

  T? get<T>(String key) {
    return _dataMap[key];
  }

  void put(String key, dynamic data) {
    _dataMap[key] = data;
  }

  T? tryGet<T>(String key) {
    var data = _dataMap[key];
    if (data is T) {
      return data;
    }
    return null;
  }

  void remove(String key) {
    _dataMap.remove(key);
  }
}
