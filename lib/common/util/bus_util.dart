import 'dart:async';

import 'package:event_bus/event_bus.dart';

class BusUtil {

  static final EventBus _eventBus = EventBus();

  //返回某事件的订阅者
  static StreamSubscription<T> listen<T extends Event>(Function(T event) onData) {
    //内部流属于广播模式，可以有多个订阅者
    return _eventBus.on<T>().listen(onData);
  }

  //发送事件
  static void fire<T extends Event>(T e) {
    _eventBus.fire(e);
  }

}

class Event {}