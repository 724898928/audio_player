import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  Player({super.key});
  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    '歌手名称',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 播放进度条
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Slider(
                      // overlayColor: WidgetStatePropertyAll(Colors.blueAccent),
                      thumbColor: Colors.blueAccent,
                      value: 20, // 当前播放进度（可以绑定实际数据）
                      max: 100, // 音乐总时长
                      onChanged: (value) {
                        // 实现进度调整
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              padding: const EdgeInsets.only(bottom: 10),
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
                    },
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {
                        // 播放或暂停
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 48,
                    onPressed: () {
                      // 下一首
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Icon(Icons.repeat),
                    iconSize: 30,
                    onPressed: () {
                      // 打开设置界面
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
