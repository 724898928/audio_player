import 'package:audio_player/src/lee/Player.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class RouterManager {
  static String playerPath = '/player';
  static String homePath = '/home';
  static String myPath = '/my';
  static String dynamicPath = '/dynamic';
  static String dynamicDetailPath = '$dynamicPath/:id';
  static FluroRouter? router;
  static void initRouter() {
    if (router == null) {
      router = FluroRouter();
      defineRoutes();
    }
  }

  static final homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Home();
  });

  static final playerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Player();
  });

  static final myHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Player();
  });

  static void defineRoutes() {
    router!.define(homePath, handler: homeHandler);
    router!.define(playerPath, handler: playerHandler);
    router!.define(myPath, handler: myHandler);
  }
}
