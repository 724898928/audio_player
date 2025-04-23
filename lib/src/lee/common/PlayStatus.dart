import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:audio_player/src/lee/model/Song.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/painting.dart';

import 'PlayUtils.dart';

class PlayStatus {
  PlayStatus._init();
  static final PlayStatus _instance = PlayStatus._init();
  factory PlayStatus() => _instance;
  static Songlist songList = Songlist.getInstance();
  static late Timer _timer;

  bool isPlaying = false;
  double pross = 0.0; // 当前播放进度
  double volume = 0.0; // 当前音量
  int currentIndex = -1; // 当前播放音乐索引
  //List<String> playList = []; // 播放列表
  int playModeIndex = 0; // 当前播放模式索引
  Duration? playTime = null; // 当前播放时间
  Duration? playTotalTime = null; // 当前播放总时间
  //  double playRate = 1.0; // 当前播放速率
  double playSpeed = 1.0; // 当前播放速度
  LinkedHashMap<int, List<Lyric>>? lyrics = null;
  String? currentlrcUrl = null;
  VoidCallback? callBack;
  static PlayStatus getInstance() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      // 每 500 毫秒执行一次
      await PlayUtils.getPosition(callback: (v) async {
        // 处理返回的数据
        print("playerThreadRun  msg1:$v");
        if (null != v && v.toString().isNotEmpty) {
          var dat = jsonDecode(v);
          _instance.playTime = Duration(milliseconds: dat['pos'].toInt());
          _instance.playTotalTime = Duration(milliseconds: dat['len'].toInt());
          _instance.playSpeed = dat['speed'].toDouble();
          //   _instance.volume = dat['vol'].toDouble();
          await _instance.updateIdxLyc(dat['idx'].toInt());
          _instance.playModeIndex = dat['mode'].toInt();
          _instance.isPlaying = dat['playing'];
          // _instance.currentlrcUrl = dat['lrcUrl'];
          var temp = dat['pos'].toDouble() / dat['len'].toDouble();
          _instance.pross = temp < 1.0 ? temp : 1.0;
          if (null != _instance.callBack) {
            _instance.callBack!.call();
          }
        }
      });
    });
    return _instance;
  }

  set setCurrentlrcUrl(String? url) {
    this.currentlrcUrl = url;
  }

  set setLyrics(LinkedHashMap<int, List<Lyric>>? lyrics) {
    this.lyrics = lyrics;
  }

  Future<dynamic> updateIdxLyc(int index) async {
    // 当切换下首个歌曲时，清空歌词,并重新加载歌词
    print("updateIdxLyc currentIndex:$currentIndex, index:$index");
    if (this.currentIndex != index) {
      var lyr = songList.proPlaySongList[index].lyrics;
      if (null != lyr && lyr.isNotEmpty && lyr.first.isNotEmpty) {
        this.currentlrcUrl = lyr.first;
        var res = await Utils.get(this.currentlrcUrl!);
        this.lyrics = LyricParser.parse(res);
      } else {
        this.lyrics = null;
        this.currentlrcUrl = null;
      }
      this.currentIndex = index;
    }
  }

  set newPlayIdx(int index) {
    this.currentIndex = index;
    this.currentlrcUrl = null;
    this.lyrics = null;
  }

  toJson() {
    return {
      "isPlaying": isPlaying,
      "pross": pross,
      "volume": volume,
      "currentIndex": currentIndex,
      "playModeIndex": playModeIndex,
      "playTime": playTime,
      "playTotalTime": playTotalTime,
      "playSpeed": playSpeed
    };
  }
}
