import 'package:flutter/material.dart';

abstract class BasePlatform {
  dynamic doSearch();
  Future<dynamic> doGetSongs(String songName, int pageNo, int pageSize);
  String getPlatformUrl();
  String setPlatformUrl();
  Widget getWidget(BuildContext ctx, Function(int, dynamic) callback);
}
