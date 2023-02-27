/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_menu.g.dart';

///create by itz on 2022/11/18 11:25
///desc :

@JsonSerializable()
class SearchMenu extends ChangeNotifier {
  int id;
  int sortKey;
  String showText;
  String searchText;

  ///[sortKey] 用于排序
  ///[showText] 展示
  ///[searchText] 实际搜索的字符
  SearchMenu(this.id, this.sortKey, this.showText, this.searchText);

  bool equals(SearchMenu? menu) {
    if (menu == null) return false;
    if (this == menu) return true;
    return sortKey == menu.sortKey && showText == menu.showText && searchText == menu.searchText;
  }

  factory SearchMenu.fromJson(Map<String, dynamic> json) => _$SearchMenuFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMenuToJson(this);

  bool selected = false;

  void setSelected(bool select) {
    selected = select;
    notifyListeners();
  }
}
