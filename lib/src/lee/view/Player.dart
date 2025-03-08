import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:audio_player/src/lee/common/PlayerIcons.dart';
import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/rust/api/simple.dart';
import 'package:audio_player/src/rust/music_service.dart';
import 'package:flutter/material.dart';

import '../common/PlayStatus.dart';
import '../component/DDownButton.dart';
import '../model/Song.dart';
import 'LyrWidget.dart';

GlobalKey<_PlayerState> _globalKey = GlobalKey();

class Player extends StatefulWidget {
  Player({super.key});
  @override
  State<StatefulWidget> createState() => _PlayerState();

  void playSong(int idx) {
    _globalKey.currentState?.playSong(idx);
  }
}

class _PlayerState extends State<Player>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
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

  Timer? _timer;

  late LyrWidget lyrWidget;

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
  void playSong(int idx) {
    this.idx = idx;
    // setCurrentPlayState();
    play(idx: BigInt.from(idx));
  }

  @override
  void initState() {
    crrentModleIcon = modleIcon[0];
    lyrWidget = LyrWidget();
    setTimer();
    setCurrentPlayState();
    super.initState();

    print("_PlayerState songList:${songList.proPlaySongList}");
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> setCurrentPlayState() async {
    isPlaying = playStatus.isPlaying;
    if (idx != playStatus.currentIndex && playStatus.currentIndex != -1) {
      idx = playStatus.currentIndex;
      await lyrWidget.clear();
    }
    print(
        "setCurrentPlayState idx:$idx, playStatus.currentIndex:${playStatus.currentIndex} ,songList.proPlaySongList.length:${songList.proPlaySongList.length}");
    if (songList.proPlaySongList.isNotEmpty &&
        idx > -1 &&
        idx < songList.proPlaySongList.length) {
      current_song = songList.proPlaySongList[idx];
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

      if (null != current_song!.lyrics && current_song!.lyrics!.isNotEmpty) {
        await lyrWidget.update(
            current_song!.lyrics?.first, playStatus.currentTime);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(
        "didChangeAppLifecycleState _timer == null : ${null == _timer} state: $state");
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
    _timer ??
        Timer.periodic(Duration(milliseconds: 500), (timer) async {
          // 每 5 秒执行一次
          await getPos().listen((v) async {
            // 处理返回的数据
            print("playerThreadRun  msg1:$v");
            if (mounted) {
              var dat = jsonDecode(v);
              // currentPross = dat['pos'] * dropdownValue;
              currentPross = dat['pos'];
              currentPross = currentPross > 1 ? 1 : currentPross;
              totalDouble = dat['len'].toDouble();
              var curttime = totalDouble! * currentPross;
              playTime = Duration(seconds: curttime.toInt());
              playStatus.setValue(
                  dat['playing'],
                  currentPross,
                  0.0,
                  dat['idx'],
                  dat['mode'],
                  playTime,
                  Duration(seconds: dat['len']),
                  dat['speed'],
                  curttime.toInt());
              setCurrentPlayState();
              setState(() {});
            }
          });
        });
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
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${current_song?.artist ?? ""}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
                                  current_song!.lyrics!.isNotEmpty)
                                await lyrWidget.update(
                                    current_song!.lyrics?.first,
                                    (totalDouble! * currentPross).toInt());
                              print("current_pross :$value");
                            },
                            onChanged: (value) async {
                              currentPross = value;

                              await seek(tm: currentPross);

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: Icon(Icons.playlist_play),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () async {
                            // 打开播放列表
                            await Utils.showListDialog(
                                context, Songlist.getInstance().proPlaySongList,
                                (i) async {
                              await lyrWidget.clear();
                              await play(idx: i);
                            });
                          },
                        ),
                        // DropSliderValueIndicatorShape(

                        // ),
                        SizedBox(width: 25),
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
                              await lyrWidget.clear();
                              await previousSong();
                              await setSpeed(v: playSpeed);
                            }
                          },
                        ),
                        SizedBox(width: 25),
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
                                  await play(idx: BigInt.from(idx));
                                  await seek(tm: currentPross);
                                  await setSpeed(v: playSpeed);
                                  setTimer();
                                } else {
                                  await pause();
                                  playIcon = Icons.play_arrow;
                                }
                                setState(() {});
                                isPlaying = !isPlaying;
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 25),
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
                              await lyrWidget.clear();
                              await setSpeed(v: playSpeed);
                              await nextSong();
                              print("nextSong");
                            }
                          },
                        ),
                        SizedBox(width: 25),
                        IconButton(
                            alignment: Alignment.center,
                            icon: Icon(crrentModleIcon['icon']),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () async {
                              mode_click =
                                  (mode_click + 1) % PlayMode.values.length;
                              await setPlayMode(
                                  mode: modleIcon[mode_click]['mode']);
                              crrentModleIcon = modleIcon[mode_click];
                              setState(() {});
                            }),
                        SizedBox(
                          width: 25,
                        ),
                        DDbutton(
                            labels: labels,
                            dropdownValue: playSpeed,
                            onChange: (v) async {
                              if (null != v) {
                                playSpeed = v;
                                await setSpeed(v: v);
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
}
