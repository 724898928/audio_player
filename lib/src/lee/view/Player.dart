import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audio_player/src/lee/common/InteractUtil.dart';
import 'package:audio_player/src/lee/common/PlayerIcons.dart';
import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/rust/music_service.dart';
import 'package:flutter/material.dart';

import '../common/PlayStatus.dart';
import '../component/DDownButton.dart';
import '../model/Song.dart';
import 'LyrWidget.dart';
import '../common/PlayUtils.dart';

class Player extends StatefulWidget {
  Player({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin
    implements InteractListener {
  // 全局播放状态.
  PlayStatus playStatus = PlayStatus.getInstance();
  Songlist songList = Songlist.getInstance();
  ProSong? current_song;
  int mode_click = 0;
  int idx = -1;
  List<Map<String, dynamic>> modleIcon = [
    {'icon': PlayerIcons.orderPlay, 'mode': PlayMode.normal},
    {'icon': Icons.repeat_rounded, 'mode': PlayMode.loop},
    {'icon': Icons.repeat_one, 'mode': PlayMode.singleLoop},
    {'icon': PlayerIcons.randomPlay, 'mode': PlayMode.random}
  ];
  late Map<String, dynamic> crrentModleIcon;

  double currentPross = 0.0;

  bool isPlaying = false;

  IconData playIcon = Icons.play_arrow;

  Duration? totalTime = null;

  double? totalDouble = null;

  Duration? playTime = null;

  double playSpeed = 1.0;

  LyrWidget lyrWidget = LyrWidget();

  NetworkImage? imgWidgets = null;

  List<Map<String, dynamic>> labels = [
    {'label': 'x4', 'value': 4.0},
    {'label': 'x3', 'value': 3.0},
    {'label': 'x2', 'value': 2.0},
    {'label': 'x1.5', 'value': 1.5},
    {'label': 'x1', 'value': 1.0},
    {'label': 'x0.75', 'value': 0.75},
    {'label': 'x0.5', 'value': 0.5},
  ];

  @override
  void initState() {
    crrentModleIcon = modleIcon[0];
    setTimer();
    setCurrentPlayState();
    super.initState();
    playStatus.callBack = setTimer;
    print("_PlayerState songList:${songList.proPlaySongList}");
    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> setCurrentPlayState() async {
    isPlaying = playStatus.isPlaying;
    idx = playStatus.currentIndex;
    print(
        "setCurrentPlayState idx:$idx, playStatus.currentIndex:${playStatus.currentIndex} ,songList.proPlaySongList.length:${songList.proPlaySongList.length}");
    if (songList.proPlaySongList.isNotEmpty &&  idx > -1 &&  idx < songList.proPlaySongList.length) {
      current_song = playStatus.current_song;
      imgWidgets = null != current_song?.imgItems?.first['img']
          ? NetworkImage(current_song?.imgItems?.first['img'])
          : null;

      currentPross = playStatus.pross;
      playSpeed = playStatus.playSpeed;
      playTime = playStatus.playTime;
      mode_click = playStatus.playModeIndex;
      crrentModleIcon = modleIcon[mode_click];
      totalTime = playStatus.playTotalTime;
      playIcon = isPlaying ? Icons.pause : Icons.play_arrow;
      await lyrWidget.update();
    }
  }

//
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState  state: $state");
    switch (state) {
      case AppLifecycleState.resumed:
        setTimer();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void setTimer() {
    print("setTimer current_song:${current_song?.title}");
    if (mounted) {
      setCurrentPlayState();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //final sl = ModalRoute.of(context)?.settings.arguments as Songlist;
    return Scaffold(
        appBar: AppBar(
          title: Text('音乐播放器'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: [
            // 背景模糊化
            _buildBlurBackground(),
            // 主内容
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 顶部音乐信息
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: imgWidgets ??
                              AssetImage(
                                  'assets/album_cover.jpg'), // 替换为你的专辑封面图片路径
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${current_song?.title ?? ""}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${current_song?.artist ?? ""}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: lyrWidget,
                  ),
                ),

                // 播放进度条
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Slider(
                            // overlayColor: WidgetStatePropertyAll(Colors.blueAccent),
                            thumbColor: Colors.blueAccent,
                            value: currentPross,
                            min: 0.0,
                            max: 1.0,
                            onChangeEnd: (value) async {
                              if (null != current_song!.lyrics &&
                                  current_song!.lyrics!.isNotEmpty) {
                                await lyrWidget.update();
                              }
                              print("current_pross :$value");
                            },
                            onChanged: (value) async {
                              currentPross = value;
                              if(null != totalTime){
                                await PlayUtils.toSeek(
                                    tm: (currentPross *
                                        totalTime!.inMilliseconds)
                                        .toInt());
                              }
                              setState(() {});
                              // 实现进度调整
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 当前播放时间
                                Text(
                                  '${playTime?.toFormattedString() ?? ""}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                // 总时长
                                Text(
                                  '${totalTime?.toFormattedString() ?? ""}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

                // 播放控制按钮
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: Icon(Icons.playlist_play),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () async {
                            // 打开播放列表
                            await Utils.showListDialog(context, Songlist.getInstance().proPlaySongList,
                                (i) async {
                               await playStatus.clearLyrics();
                              await PlayUtils.toPlay(idx: i);
                            });
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: Icon(Icons.skip_previous),
                          color: Colors.white,
                          iconSize: 48,
                          onPressed: () async {
                            // 上一首
                            if (Songlist.getInstance()
                                .proPlaySongList
                                .isNotEmpty) {
                              await PlayStatus.getInstance().clearLyrics();
                              await PlayUtils.toPrevious();
                              await PlayUtils.toSpeed(s: playSpeed);
                            }
                          },
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(playIcon),
                            iconSize: 25,
                            color: Colors.white,
                            onPressed: () async {
                              if (Songlist.getInstance()
                                  .proPlaySongList
                                  .isNotEmpty) {
                                // 播放或暂停
                                if (!isPlaying) {
                                  playIcon = Icons.pause;
                                  await PlayUtils.toPlay(idx: idx);
                                  if(null != totalTime){
                                    await PlayUtils.toSeek(
                                        tm: (currentPross *
                                            totalTime!.inMilliseconds)
                                            .toInt());
                                  }
                                  await PlayUtils.toSpeed(s: playSpeed);
                                  setTimer();
                                } else {
                                  await PlayUtils.toPause(callback: (v) async {
                                    playIcon = Icons.play_arrow;
                                  });
                                }
                                setState(() {});
                                isPlaying = !isPlaying;
                              }
                            },
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: Icon(Icons.skip_next),
                          color: Colors.white,
                          iconSize: 48,
                          onPressed: () async {
                            // 下一首
                            if (Songlist.getInstance()
                                .proPlaySongList
                                .isNotEmpty) {
                              await PlayStatus.getInstance().clearLyrics();
                              await PlayUtils.toSpeed(s: playSpeed);
                              await PlayUtils.toNext();
                              print("nextSong");
                            }
                          },
                        ),
                        IconButton(
                            alignment: Alignment.center,
                            icon: Icon(crrentModleIcon['icon']),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () async {
                              mode_click = (mode_click + 1) % PlayMode.values.length;
                              await PlayUtils.toPlayMode(
                                  mode: modleIcon[mode_click]['mode']);
                              crrentModleIcon = modleIcon[mode_click];
                              setState(() {});
                            }),
                        if (!Platform.isAndroid)
                          DDbutton(
                              labels: labels,
                              dropdownValue: playSpeed,
                              onChange: (v) async {
                                if (null != v) {
                                  playSpeed = v;
                                  await PlayUtils.toSpeed(s: v);
                                  print("DDbutton onChange value:$v");
                                }
                              })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true; // keepAlive

  Widget _buildBlurBackground() {
    return Stack(
      children: [
        Image.network(
          'https://picsum.photos/800/800',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  @override
  void onError(Object error) {
    // TODO: implement onError
  }

  @override
  void onEvent(Object event) {
    print("onEvent event:$event");
  }
}
