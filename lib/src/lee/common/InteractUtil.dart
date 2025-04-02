import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class InteractUtil {

  static const String CALL_ANDROID_CHANNEL = "com.lee/call_native";

  static const String CALL_FLUTTER_CHANNEL = "com.lee/call_flutter";

  static const EventChannel eventChannel = EventChannel(CALL_FLUTTER_CHANNEL);

  static const MethodChannel callNativeMethodChannel = MethodChannel(CALL_ANDROID_CHANNEL);

  static InteractUtil _instance = InteractUtil._internal();

  List<InteractListener> listenerList = [];

  factory InteractUtil() => _getInstance();

   static InteractUtil get instance => InteractUtil._internal();


  InteractUtil._internal() {
    print("InteractUtil._internal ");
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

  }
  // Stream<int> _batteryEvents() {
  //   return _eventChannel.receiveBroadcastStream().map((event) => event as int);
  //}

// 在 UI 中监听事件流
//   StreamBuilder<int>(
//   stream: _batteryEvents(),
//   builder: (context, snapshot) {
//   return Text('Battery Event: ${snapshot.data}');
//   },
//  )

  static InteractUtil _getInstance() {
    _instance ?? InteractUtil._internal();
    return _instance;
  }

  static void setCallback(Future<void> Function(MethodCall call) handler){
    callNativeMethodChannel.setMethodCallHandler(handler);
  }

  // 注册回调函数(必须时一个顶级函数)
  static void registerCallback(Function topCallback){
    final callback = PluginUtilities.getCallbackHandle(topCallback);
    callNativeMethodChannel.invokeMethod("registerCallback",callback?.toRawHandle());
  }



  void addListener(InteractListener listener) {
    if (null == listener) {
      return;
    }
    listenerList.add(listener);
  }

  void _onEvent(dynamic event) {
    print("_onEvent is invoke $event");
    if(null != listenerList || listenerList.isNotEmpty){
      for (InteractListener listener in listenerList) {
        listener.onEvent(event);
      }
    }
  }

  void _onError(Object error) {
    for (InteractListener listener in listenerList) {
      listener.onError(error);
    }
  }

  /**
   * flutter call the method of android native
   */
  Future<dynamic> androidExe(String? method,dynamic arguments) async{

    if(null == method || method.isEmpty){
      return "";
    }
   // print("androidExe method :$method ,arguments:$arguments");
    return await callNativeMethodChannel.invokeMethod(method, arguments);
  }

}

abstract class InteractListener {
  void onEvent(Object event);

  void onError(Object error);

}

// 另一个isolate入口函数
void callback(){
  WidgetsFlutterBinding.ensureInitialized();
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, "player ");
  receivePort.listen((message) {
    switch (message){
      case "android":
        print('WidgetsFlutterBinding callback android');
        break;
    }
  });
  print('WidgetsFlutterBinding callback');
}