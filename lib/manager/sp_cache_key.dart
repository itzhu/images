/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:convert';

import '../common/util/sp_util.dart';
import '../pages/datas/search_menu.dart';

///create by itz on 2022/11/21 10:09
///desc : 
class SpCacheKey{

  ///主界面菜单， 壁纸，动漫...
  static const String SP_KEY_MENU_LIST = "SP_KEY_MENU_LIST";
  ///当前选中的菜单项
  static const String SP_KEY_MENU_SELECT_POSITION = "SP_KEY_MENU_SELECT_POSITION";

  static void saveMenus({List<SearchMenu>? menus, int? selectPosition}) {
    if (menus != null) {
      SpUtil.put(SP_KEY_MENU_LIST, jsonEncode(menus, toEncodable: (Object? value) => (value as SearchMenu).toJson()));
    }
    if (selectPosition != null) {
      SpUtil.put(SP_KEY_MENU_SELECT_POSITION, selectPosition);
    }
  }


}