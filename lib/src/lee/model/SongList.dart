import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/model/Song.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../common/DatabaseHelper.dart';

// the list to play
class Songlist extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  // 私有构造函数
   List<ProSong> proPlaySongList = [];

  Songlist._iniernal(){
    Future.delayed(Duration.zero,()async{
      proPlaySongList = await _dbHelper.getSongs();
      PlayUtils.setList2Player(songs: proPlaySongList.map((e) => e.url ?? "").toList());
    });
  }

  static Songlist _singleton = Songlist._iniernal();

  factory Songlist() => _singleton;

  static Songlist getInstance() {
    _singleton ??= Songlist._iniernal();
    return _singleton;
  }


  int add(ProSong item) {
    if (!proPlaySongList.contains(item)) {
      proPlaySongList.add(item);
      PlayUtils.addSongList(songs: [item.url ?? ""]);
      Future.delayed(Duration.zero,()async{
        await _dbHelper.addSong(item);
      });
      notifyListeners();
    }
    return proPlaySongList.length - 1;
  }

  Future<void> addSongs(List<ProSong> items) async {
    if (!proPlaySongList.contains(items)) {
      proPlaySongList.addAll(items);
      PlayUtils.addSongList(songs: items.map((e) => e.url ?? "").toList());
      await _dbHelper.batchInsert(items);
      print("proPlaySongList :$proPlaySongList");
      notifyListeners();
    }
  }

  Future<void> remove(ProSong item) async{
    var idx = proPlaySongList.indexOf(item);
    proPlaySongList.removeAt(idx);
   await PlayUtils.removeSong(idx);
   await _dbHelper.delSong(item);
    notifyListeners();
  }

}
