import 'dart:async';

import 'package:audio_player/src/lee/component/ChangeNotifierProvider.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/rust/api/simple.dart';
import 'package:audio_player/src/rust/music_service.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  Player({super.key});
  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String song_context = "";
  String? singer;
  int mode_click = 0;  // 乱序
  List<IconData> modleIcon = [Icons.looks_one_rounded, Icons.repeat_rounded, Icons.repeat_one, Icons.open_in_full_rounded];
  IconData crrentModleIcon = Icons.looks_one_rounded;

  double current_pross = 0.0;
  bool is_playing = false;
  IconData playIcon = Icons.play_arrow;

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
                      value: current_pross, // 当前播放进度（可以绑定实际数据）
                      min: 0.0,
                      max: 1.0, // 音乐总时长
                      onChanged: (value) {
                        current_pross = value;
                        print("current_pross :$current_pross");
                        seek(tm: current_pross);
                        setState(() {});
                        // 实现进度调整
                      },
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '01:25', // 当前播放时间
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '04:30', // 总时长
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
                    onPressed: () {
                      // 上一首
                    previousSong();
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
                      onPressed: () {
                        // 播放或暂停
                        if(!is_playing){
                          playIcon = Icons.pause;
                          play();
                          seek(tm: current_pross);
                          Timer.periodic(Duration(milliseconds: 500), (timer) async {
                            // 每 5 秒执行一次
                            getPos().listen((v){
                              // 处理返回的数据
                              current_pross = double.parse(v) ;
                              current_pross = current_pross  > 1 ? 1 : current_pross;
                              setState(() {
                              });
                              print("playerThreadRun  msg:$current_pross");
                            });
                          });
                        }else{
                          pause();
                          playIcon = Icons.play_arrow;
                          setState(() {
                          });
                        }
                        is_playing = !is_playing;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 48,
                    onPressed: () {
                      // 下一首
                      nextSong();
                      print("nextSong");
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Icon(crrentModleIcon),
                    iconSize: 30,
                    onPressed: () {
                      PlayMode.values.forEach((v) {
                        print(" v.index:${v.index} , mode_click:$mode_click");
                        if (v.index == mode_click) {
                          crrentModleIcon = modleIcon[v.index];
                          setPlayMode(mode: v);
                        }else if(PlayMode.values.length <= mode_click){
                          mode_click = 0;
                          crrentModleIcon = modleIcon[mode_click];
                        }
                        setState(() {});
                      });
                      mode_click+=1;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
