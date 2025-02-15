import 'package:flutter/material.dart';
import 'dart:ui';

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

  final List<Lyric> _lyrics = [
    Lyric(time: '00:00', text: '开始演奏...'),
    Lyric(time: '00:15', text: '这一路上走走停停'),
    Lyric(time: '00:20', text: '顺着少年漂流的痕迹'),
    Lyric(time: '00:25', text: '迈出车站的前一刻'),
    Lyric(time: '00:30', text: '竟有些犹豫'),
    Lyric(time: '00:35', text: '不禁笑这近乡情怯'),
    Lyric(time: '00:40', text: '仍无可避免'),
    Lyric(time: '00:45', text: '而长野的天'),
    Lyric(time: '00:50', text: '依旧那么暖'),
    Lyric(time: '00:55', text: '风吹起了从前'),
  ];

  @override
  void initState() {
    super.initState();
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
              _buildProgressBar(),
              _buildControlButtons(),
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
                Text(_lyrics[_currentLyricIndex].time),
                Text(_lyrics.last.time),
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

class Lyric {
  final String time;
  final String text;

  Lyric({required this.time, required this.text});
}
