import 'package:flutter/foundation.dart';

class Songlist extends ChangeNotifier {
  // 私有构造函数

  Songlist._iniernal();

  static Songlist _singleton = Songlist._iniernal();

  factory Songlist() => _singleton;

  //
  final List<Map<Object, dynamic>> selectSongList = [];
  final List<Map<Object, dynamic>> proPlaySongList = [];

  void add(dynamic item) {
    proPlaySongList.add(item);
    notifyListeners();
  }
}
