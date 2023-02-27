/*年轻人，只管向前看，不要管自暴自弃者的话*/

///create by itz on 2022/11/21 18:40
///desc :
class IDCreator {
  static int _id = 0;

  static int createId() {
    if (_id > 1000000) {
      _id = 0;
    }
    return _id++;
  }
}
