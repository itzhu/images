/*摆脱冷气，只是向上走，不必听自暴自弃者流的话。*/

///@name  : list_util
///@author: create by  itzhu |  2022/5/27
///@desc  :
class ListUtil {
  static bool isNullOrEmpty(List? data) {
    if (data == null || data.isEmpty) {
      return true;
    }
    return false;
  }

  static String listToString(List list, {String? split}) {
    StringBuffer sb = StringBuffer();
    var sp = "";
    for (var data in list) {
      sb.write(sp);
      sb.write(data);
      sp = split ?? "";
    }
    return sb.toString();
  }



}
