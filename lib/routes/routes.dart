/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:fluro/fluro.dart';

import '../pages/page_ftools_test.dart';
import '../pages/page_image_index.dart';
import '../pages/page_setting.dart';

///create by itz on 2022/11/14 11:48
///desc :

class Routes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String ftoolsTest = '/ftoolsTest';

  static FluroRouter create() {
    FluroRouter router = FluroRouter();
    router.define(home, handler: Handler(handlerFunc: (context, parameters) => const IndexPage()));
    router.define(settings, handler: Handler(handlerFunc: (context, parameters) => const SettingsPage()));
    router.define(ftoolsTest, handler: Handler(handlerFunc: (context, parameters) => const FtoolsTestPage()));
    return router;
  }
}
