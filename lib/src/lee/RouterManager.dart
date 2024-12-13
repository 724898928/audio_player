import 'package:audio_player/src/lee/Player.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'Search.dart';
import 'My.dart';

class RouterManager {
  static String playerPath = '/player';
  static String searchPath = '/home';
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

  static final homeMyListWidget = [Search(), My(), Player()];
  static final homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return homeMyListWidget[0];
  });
  static final myHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return homeMyListWidget[1];
  });

  static final playerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return homeMyListWidget[2];
  });

  static void defineRoutes() {
    router!.define(searchPath, handler: homeHandler);
    router!.define(playerPath, handler: playerHandler);
    router!.define(myPath, handler: myHandler);
  }
}
