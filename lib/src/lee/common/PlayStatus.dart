import 'dart:collection';

import 'package:audio_player/src/lee/model/Song.dart';

class PlayStatus {
  PlayStatus._init();
  static final PlayStatus _instance = PlayStatus._init();
  factory PlayStatus() => _instance;
  static PlayStatus getInstance() {
    return _instance;
  }

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
  int currentTime = 0; // 当前播放时间 s单位 ,
  setValue(
    bool isPlaying,
    double pross,
    double volume,
    int currentIndex,
    int playModeIndex,
    Duration? playTime,
    Duration? playTotalTime,
    double playSpeed,
    int currentTime,
  ) {
    this.isPlaying = isPlaying;
    this.pross = pross;
    this.volume = volume;
    this.currentIndex = currentIndex;
    this.playModeIndex = playModeIndex;
    this.playTime = playTime;
    this.playTotalTime = playTotalTime;
    this.playSpeed = playSpeed;
    this.currentTime = currentTime;
  }

  set setCurrentlrcUrl(String? url) {
    this.currentlrcUrl = url;
  }

  set setLyrics(LinkedHashMap<int, List<Lyric>>? lyrics) {
    this.lyrics = lyrics;
  }

  set setCurrentIndex(int index) {
    this.currentIndex = index;
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
