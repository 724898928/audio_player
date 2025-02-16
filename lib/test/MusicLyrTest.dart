import 'package:flutter/material.dart';
import 'dart:ui';

import '../src/lee/model/Song.dart';

void main() => runApp(MusicPlayerApp());

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '音乐播放器',
      theme: ThemeData.dark(),
      home: MusicPlayerPage(),
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentLyricIndex = 0;
  bool _isPlaying = true;
  double _progressValue = 0.3;
  final String lrc = "@migu music@ \n" +
      "[00:00.20]漠河舞厅-张玉玉（原唱：柳爽） \n" +
      "[00:01.48]作词：柳爽 \n" +
      "[00:02.22]作曲：柳爽 \n" +
      "[00:14.44]我从没有见过极光出现的村落 \n" +
      "[00:20.26]也没有见过有人 在深夜放烟火 \n" +
      "[00:27.46]晚星就像你的眼睛杀人又放火 \n" +
      "[00:33.81]你什么都没有说 野风惊扰我 \n" +
      "[00:41.06]三千里 偶然见过你 \n" +
      "[00:47.51]花园里 有裙翩舞起 \n" +
      "[00:54.16]灯光底 抖落了晨曦 \n" +
      "[01:00.75]在1980的漠河舞厅 \n" +
      "[01:08.13]如果有时间 \n" +
      "[01:10.32]你会来看一看我吧 \n" +
      "[01:13.68]看大雪如何衰老的 \n" +
      "[01:16.82]我的眼睛如何融化 \n" +
      "[01:20.35]如果你看见我的话 \n" +
      "[01:23.65]请转过身去再惊讶 \n" +
      "[01:27.74]我怕我的眼泪我的白发像羞耻的笑话 \n" +
      "[01:52.42]我从没有见过极光出现的村落 \n" +
      "[01:58.27]也没有见过有人 在深夜放烟火 \n" +
      "[02:05.08]晚星就像你的眼睛杀人又放火 \n" +
      "[02:11.59]你什么都不必说 野风惊扰我 \n" +
      "[02:19.02]可是你 惹怒了神明 \n" +
      "[02:25.03]让你去 还那么年轻 \n" +
      "[02:32.38]都怪你 远山冷冰冰 \n" +
      "[02:38.73]在一个人的漠河舞厅 \n" +
      "[02:46.06]我从没有见过极光出现的村落 \n" +
      "[02:52.26]也没有见过有人 在深夜放烟火 \n" +
      "[02:59.23]晚星就像你的眼睛杀人又放火 \n" +
      "[03:05.80]你什么都不必说 野风惊扰我 \n" +
      "[03:14.67]";
  late List<Lyric> _lyrics;

  @override
  void initState() {
    super.initState();
    _lyrics = LyricParser.parse(lrc);
    _simulatePlayback();
  }

  void _simulatePlayback() async {
    while (_isPlaying) {
      await Future.delayed(Duration(seconds: 2));
      if (_currentLyricIndex < _lyrics.length - 1) {
        setState(() {
          _currentLyricIndex++;
          _progressValue = _currentLyricIndex / (_lyrics.length - 1);
        });
        _scrollToCurrentLyric();
      }
    }
  }

  void _scrollToCurrentLyric() {
    final double itemHeight = 60;
    final double targetPosition = _currentLyricIndex * itemHeight;

    _scrollController.animateTo(
      targetPosition - (MediaQuery.of(context).size.height / 2 - itemHeight),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 模糊背景
          _buildBlurBackground(),
          // 主要内容
          Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildLyricsList()),
              // _buildProgressBar(),
              // _buildControlButtons(),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('起风了', style: TextStyle(fontSize: 18)),
          Text('歌手：买辣椒也用券', style: TextStyle(fontSize: 14)),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildLyricsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(20),
      itemCount: _lyrics.length,
      itemBuilder: (context, index) {
        final isCurrent = index == _currentLyricIndex;
        return Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isCurrent ? 24 : 18,
              color: isCurrent ? Colors.white : Colors.white70,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(_lyrics[index].text),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Slider(
            value: _progressValue,
            onChanged: (value) {
              setState(() {
                _progressValue = value;
                _currentLyricIndex = (value * (_lyrics.length - 1)).round();
              });
            },
            activeColor: Colors.white,
            inactiveColor: Colors.white38,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_lyrics[_currentLyricIndex].time.toString()),
                Text(_lyrics.last.time.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.skip_previous, size: 32),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 48,
            ),
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next, size: 32),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
