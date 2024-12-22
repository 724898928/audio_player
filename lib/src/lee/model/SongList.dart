import 'package:flutter/foundation.dart';

class Songlist extends ChangeNotifier {
  // 私有构造函数

  Songlist._iniernal();

  static Songlist _singleton = Songlist._iniernal();

  factory Songlist() => _singleton;

  static Songlist getInstance() {
    _singleton ??= Songlist._iniernal();
    return _singleton;
  }

  //
  final List<Map<Object, dynamic>> selectSongList = [];
  final List<String> proPlaySongList = [];

  void add(dynamic item) {
    proPlaySongList.add(item);
    notifyListeners();
  }

  void addSongs(List<String> item) {
    proPlaySongList.addAll(item);
    print("proPlaySongList :$proPlaySongList");
    notifyListeners();
  }
}
