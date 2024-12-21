import 'dart:async';
import 'dart:convert';

import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:audio_player/src/lee/component/ChangeNotifierProvider.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/rust/api/simple.dart';
import 'package:audio_player/src/rust/music_service.dart';
import 'package:flutter/material.dart';

import '../component/DDownButton.dart';

class Player extends StatefulWidget {
  Player({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with AutomaticKeepAliveClientMixin {
  String song_context = "";
  String? singer;
  int mode_click = 0; // 乱序
  List<IconData> modleIcon = [
    Icons.looks_one_rounded,
    Icons.repeat_rounded,
    Icons.repeat_one,
    Icons.open_in_full_rounded
  ];
  IconData crrentModleIcon = Icons.looks_one_rounded;

  double current_pross = 0.0;

  bool is_playing = false;

  IconData playIcon = Icons.play_arrow;

  String? total_d = "";

  String? current_d = "";

  double? dropdownValue = 1.0;

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
    // TODO: implement initState
    super.initState();
    setPlaylist(songs: [
      "D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3",
      "D:\\flutter_pro\\audio_player\\rust\\src\\music\\118806715.mp3",
      "D:\\flutter_pro\\audio_player\\rust\\src\\music\\614252728.mp3"
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sl = ModalRoute.of(context)?.settings.arguments as Songlist;
    if (sl.proPlaySongList.isNotEmpty) {
      singer = sl.proPlaySongList.first.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('简约音乐播放器'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 顶部音乐信息
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        AssetImage('assets/album_cover.jpg'), // 替换为你的专辑封面图片路径
                  ),
                  SizedBox(height: 20),
                  Text(
                    '歌曲名称',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    //  '歌手名称',
                    singer ?? "歌手名称00000",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(song_context)
                ],
              ),
            ),
          ),
          // 播放进度条
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Slider(
                      // overlayColor: WidgetStatePropertyAll(Colors.blueAccent),
                      thumbColor: Colors.blueAccent,
                      value: current_pross,
                      // 当前播放进度（可以绑定实际数据）
                      min: 0.0,
                      max: 1.0,
                      // 音乐总时长
                      onChanged: (value) {
                        current_pross = value;
                        print("current_pross :$current_pross");
                        seek(tm: current_pross);
                        setState(() {});
                        // 实现进度调整
                      },
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 当前播放时间
                          Text(
                            '$current_d',
                            style: TextStyle(color: Colors.grey),
                          ),
                          // 总时长
                          Text(
                            '$total_d',
                            style: TextStyle(color: Colors.grey),
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
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.playlist_play),
                    iconSize: 30,
                    onPressed: () {
                      // 打开播放列表
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 48,
                    onPressed: () async {
                      // 上一首
                      await previousSong();
                      await setSpeed(v: dropdownValue!);
                    },
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: Icon(playIcon),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () async {
                        // 播放或暂停
                        if (!is_playing) {
                          playIcon = Icons.pause;
                          await play();
                          await seek(tm: current_pross);
                          await setSpeed(v: dropdownValue!);
                          Timer.periodic(Duration(milliseconds: 500),
                              (timer) async {
                            // 每 5 秒执行一次
                            await getPos().listen((v) {
                              // 处理返回的数据
                              print("playerThreadRun  msg1:$v");
                              if (mounted) {
                                var dat = jsonDecode(v);
                                current_pross = dat['pos'];
                                current_pross =
                                    current_pross > 1 ? 1 : current_pross;
                                total_d = Duration(seconds: dat['len'])
                                    .toFormattedString();
                                current_d = Duration(
                                        seconds: (dat['len'].toDouble() *
                                                current_pross)
                                            .toInt())
                                    .toFormattedString();
                                print(
                                    "playerThreadRun dat:$dat, len:${dat['len']}  msg:$current_pross");
                                setState(() {});
                                print("playerThreadRun  msg2:$current_pross");
                              } else {
                                timer.cancel();
                              }
                            });
                          });
                        } else {
                          await pause();
                          playIcon = Icons.play_arrow;
                        }
                        setState(() {});
                        is_playing = !is_playing;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 48,
                    onPressed: () async {
                      // 下一首
                      await nextSong();
                      await setSpeed(v: dropdownValue!);
                      print("nextSong");
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Icon(crrentModleIcon),
                    iconSize: 30,
                    onPressed: () async {
                      PlayMode.values.forEach((v) async {
                        print(" v.index:${v.index} , mode_click:$mode_click");
                        if (v.index == mode_click) {
                          crrentModleIcon = modleIcon[v.index];
                          await setPlayMode(mode: v);
                        } else if (PlayMode.values.length <= mode_click) {
                          mode_click = 0;
                          crrentModleIcon = modleIcon[mode_click];
                        }
                        setState(() {});
                      });
                      mode_click += 1;
                    },
                  ),
                  DDbutton(
                      labels: labels,
                      onChange: (v) async {
                        if (null != v) {
                          dropdownValue = v;
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
