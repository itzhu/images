/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:images/common/util/id_creator.dart';
import 'package:images/common/util/log_util.dart';
import 'package:images/common/util/sp_util.dart';
import 'package:images/manager/sp_cache_key.dart';
import 'package:provider/provider.dart';

import '../../apis/ImagesApi.dart';
import '../../app_const.dart';
import 'search_menu.dart';
import '../../apis/jsons.dart' as img;

import 'package:async/async.dart';

///create by itz on 2022/11/18 11:09
///desc :
///
class IndexData extends ChangeNotifier implements ReassembleHandler {
  @override
  void reassemble() {
    LogUtil.d(TAG, 'Did hot-reload');
  }

  static const String TAG = "IndexData";

  ///标签列表
  final MenuData menuData = MenuData();

  ///当前选中的加载数据
  final LoadData loadData = LoadData();

  ///当前选中的标签
  SearchMenu? selectMenu;

  ///标记数据初始化
  bool dataInit = false;

  ///初始化数据
  Future<void> init() async {
    String menuStr = await SpUtil.get(SpCacheKey.SP_KEY_MENU_LIST, "");
    List<SearchMenu>? menus;
    try {
      if (menuStr.isNotEmpty) {
        menus = ((jsonDecode(menuStr) as List<dynamic>)
            .map((e) => SearchMenu.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (e) {
      LogUtil.e(TAG, "ERR:$e");
      await SpUtil.put(SpCacheKey.SP_KEY_MENU_LIST, "");
    }
    if (menus == null || menus.isEmpty) {
      menus = []
        ..add(SearchMenu(100, 0, "壁纸", "壁纸"))
        ..add(SearchMenu(101, 1, "动漫", "动漫"))
        ..add(SearchMenu(102, 2, "美女", "美女"))
        ..add(SearchMenu(103, 3, "风景", "风景"))
        ..add(SearchMenu(104, 4, "天气", "天气"))
        ..add(SearchMenu(105, 5, "表情包", "表情包"));
    }
    menuData.setMenus(menus);
    var selectMenuId = await SpUtil.get(SpCacheKey.SP_KEY_MENU_SELECT_POSITION, 0);
    for (var data in menus) {
      if (data.id == selectMenuId) {
        setSelectMenu(data);
        break;
      }
    }

    if (selectMenu == null) {
      setSelectMenu(menuData.get(0)!);
    }

    setDataInit(true);
  }

  ///数据初始化完成
  void setDataInit(bool init) {
    dataInit = init;
    notifyListeners();
  }

  ///添加菜单
  void addMenu(String text, bool select) {
    var menu = menuData.searchByText(text);
    if (menu == null) {
      menu = SearchMenu(DateTime.now().millisecondsSinceEpoch, -1, text, text);
      menuData
        ..add(menu)
        ..sort()
        ..save()
        ..notify();
      setSelectMenu(menu);
    } else {
      if (menu.selected) return;
      setSelectMenu(menu);
    }
  }

  ///删除菜单
  void deleteMenu(SearchMenu menu) {
    menuData
      ..delete(menu)
      ..sort()
      ..save()
      ..notify();
    if (menu.id == selectMenu?.id) {
      var menu = menuData.get(0);
      if (menu != null) {
        setSelectMenu(menu);
      } else {
        //TODO:itz:2022/11/22 9:23:菜单都删完了。
      }
    }
  }

  ///当前选中的数据变化了
  void setSelectMenu(SearchMenu menu) {
    if (selectMenu?.id == menu.id) return;
    //设置选中菜单
    selectMenu?.setSelected(false);
    selectMenu = menu;
    selectMenu?.setSelected(true);
    notifyListeners();

    SpUtil.put(SpCacheKey.SP_KEY_MENU_SELECT_POSITION, selectMenu?.id);
    //开始加载数据
    loadImageList(word: menu.searchText);
  }

  //网络请求--------------------------------------------------------------------------------------------------------------------
  ///请求回调
  OnLoadListener? onLoadListener;
  int _requestId = 0;

  ///用于取消请求
  CancelableOperation<int>? _requestCancelOperation;

  void loadMore({int? requestId}) {
    cancelRequest();
    _requestId = requestId ?? IDCreator.createId();
    _requestCancelOperation = CancelableOperation.fromFuture(Future(() async {
      var code = await loadData.loadMore();
      if (_requestId != 0) {
        var id = _requestId;
        _requestId = 0;
        onLoadListener?.onFinish.call(id, code, null);
      }
      return Future.value(0);
    }));
  }

  void loadImageList({int? requestId, required String word, int pageNumber = 0, int? color, int? width, int? height}) {
    cancelRequest();
    _requestId = requestId ?? IDCreator.createId();
    _requestCancelOperation = CancelableOperation.fromFuture(Future(() async {
      var code =
          await loadData.loadImageList(word: word, pageNumber: pageNumber, color: color, width: width, height: height);
      if (_requestId != 0) {
        var id = _requestId;
        _requestId = 0;
        onLoadListener?.onFinish.call(id, code, null);
      }
      return Future.value(0);
    }));
  }

  void cancelRequest() {
    if (_requestId != 0) {
      var id = _requestId;
      _requestId = 0;
      onLoadListener?.onFinish.call(id, AppCode.REQUEST_CANCEL, null);
    }

    if (_requestCancelOperation != null) {
      if (!_requestCancelOperation!.isCompleted || !_requestCancelOperation!.isCanceled) {
        _requestCancelOperation?.cancel();
        _requestCancelOperation = null;
      }
    }
  }

  void setLoadListener(OnLoadListener? onLoadListener) {
    this.onLoadListener = onLoadListener;
  }

//网络请求--------------------------------------------------------------------------------------------------------------------

}

class OnLoadListener {
  Function(int requestId) onStart;
  Function(int requestId, int code, dynamic data) onFinish;

  OnLoadListener({required this.onStart, required this.onFinish});
}

class LoadParams {
  String word = "";
  int pageNumber = 0;
  int? color;
  int? width;
  int? height;
}

class LoadData extends ChangeNotifier {
  static const TAG = "LoadData";

  final LoadParams _loadParams = LoadParams();
  final List<img.ImageInfo> _imgList = [];
  bool _loading = false;

  List<img.ImageInfo> get imgList => _imgList;

  bool get isLoading => _loading;

  int lastUpdateTime = 0;

  Future<int> loadMore() => loadImageList(word: _loadParams.word, pageNumber: _loadParams.pageNumber + 1);

  ///return [AppCode.REQUEST_SUCCESS]\[AppCode.REQUEST_ERROR_DATA]\[AppCode.REQUEST_ERROR_PARAMS]\HTTP code
  Future<int> loadImageList({required String word, int pageNumber = 0, int? color, int? width, int? height}) async {
    //检查是否为数据变化，而不是加载下一页
    if (_loadParams.word != word ||
        _loadParams.color != color ||
        _loadParams.width != width ||
        _loadParams.height != height) {
      //条件变化，需要清空之前的数据
      _imgList.clear();
      _loadParams.pageNumber = 0;
      _loadParams.word = word;
      _loadParams.color = color;
      _loadParams.width = width;
      _loadParams.height = height;
      notifyListUpdate();
    } else {
      //加载下一页
      if (pageNumber < _loadParams.pageNumber) {
        //数据有问题，不加载
        return Future.value(AppCode.REQUEST_ERROR_PARAMS);
      }
    }
    _loading = true;
    var url = ImagesApi.getImgListUrl(
        word: word, pageIndexNumber: pageNumber * 30, rangeNumber: 30, color: color, width: width, height: height);
    var json = await ImagesApi.getImagesJson(url);
    var retCode = json.code;
    if (json.data != null) {
      _loadParams.pageNumber = pageNumber;
      for (var data in json.data!.data!) {
        if (data.isValid()) {
          _imgList.add(data);
        } else {
          LogUtil.e(TAG, "无效数据：${data.toJson()}");
        }
      }
    }
    _loading = false;
    notifyListUpdate();
    return Future.value(retCode);
  }

  void notifyListUpdate() {
    lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }
}

class MenuData extends ChangeNotifier {
  final List<SearchMenu> _menus = [];

  SearchMenu? get(int position) {
    return _menus[position];
  }

  int indexOf(SearchMenu menu) {
    return _menus.indexOf(menu);
  }

  int size() {
    return _menus.length;
  }

  void add(SearchMenu menu) {
    if (!_menus.contains(menu)) {
      _menus.add(menu);
    }
  }

  void delete(SearchMenu menu) {
    _menus.remove(menu);
  }

  void setMenus(List<SearchMenu> menus) {
    _menus.clear();
    _menus.addAll(menus);
  }

  void sort() {
    _menus.sort((a, b) => a.sortKey.compareTo(b.sortKey));
    for (int i = 0; i < _menus.length; i++) {
      _menus[i].sortKey = i;
    }
  }

  SearchMenu? searchByText(String text) {
    for (SearchMenu data in _menus) {
      if (data.searchText == text) return data;
    }
    return null;
  }

  void save() {
    SpCacheKey.saveMenus(menus: _menus);
  }

  List<SearchMenu> menus() {
    return _menus;
  }

  var lastUpdateTime = 0;

  void notify() {
    lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }
}
