typedef void EventCallback(arg);

class EventBus {
  // 私有构造函数
  EventBus._iniernal();
  // 保存单例
  static EventBus _singleton = EventBus._iniernal();

  // 工厂构造函数
  factory EventBus() => _singleton;

  // 保存事件订阅者队列, key:事件名(id), value: 对应事件的订阅者队列
  final _emap = <Object, List<EventCallback>?>{};

  // 添加订阅者
  void on(eventName, EventCallback f) {
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]!.add(f);
  }

  // 移除订阅者

  void off(eventName, [EventCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件, 事件触发后该事件所有订阅者被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    // int len = list.length - 1;
    // 反向遍历, 防止订阅者在回调中移除自身带来的下标错误
    list.forEach((item) => item(arg));
    // for (var i = len; i > -1; --i) {
    //   list[i](arg);
    // }
  }
}
