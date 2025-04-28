import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/model/Song.dart';
import 'package:flutter/foundation.dart';

// the list to play
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
  //final List<Map<Object, dynamic>> selectSongList = [];
  final List<ProSong> proPlaySongList = [];

  int add(ProSong item) {
    if (!proPlaySongList.contains(item)) {
      proPlaySongList.add(item);
      PlayUtils.addSongList(songs: [item.url ?? ""]);
      notifyListeners();
    }
    return proPlaySongList.length - 1;
  }

  void addSongs(List<ProSong> item) {
    if (!proPlaySongList.contains(item)) {
      proPlaySongList.addAll(item);
      PlayUtils.addSongList(songs: item.map((e) => e.url ?? "").toList());
      print("proPlaySongList :$proPlaySongList");
      notifyListeners();
    }
  }

  void remove(ProSong item) {
    proPlaySongList.remove(item);
    PlayUtils.setList2Player(songs: proPlaySongList.map((e) => e.url ?? "").toList());
    notifyListeners();
  }
}
