import 'package:flutter/material.dart';

import '../common/Utils.dart';
import '../model/Song.dart';
import 'Player.dart';

class LyrWidget extends StatefulWidget {
  LyrWidget({super.key});
  _LyrWidgetState lyrWidgetState = _LyrWidgetState();
  @override
  State<LyrWidget> createState() => lyrWidgetState;

  Future<void> update(
    String url,
    int currentTime,
    OptionsType type,
  ) async {
    await lyrWidgetState.update(url, currentTime, type);
  }
}

class _LyrWidgetState extends State<LyrWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentLyricIndex = 0;
  String? lrcUrl = null;

  late List<Lyric> _lyrics = [];

  @override
  initState() {
    super.initState();
    // if (null != lrc && lrc!.isNotEmpty) {
    //   _lyrics = LyricParser.parse(lrc!);
    //   _simulatePlayback();
    // }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> update(
    String url,
    int currentTime,
    OptionsType type,
  ) async {
    print("update url: $url , currenttime: $currentTime");
    if (lrcUrl != url) {
      lrcUrl = url;
      await getLrc(url, (res) {
        if (null != res) {
          print("update res: $res");
          _lyrics = LyricParser.parse(res);
        }
        setState(() {});
      });
    }
    if (OptionsType.Slider == type) {
      print("OptionsType.Slider");
      _lyrics.asMap().entries.map((e) {
        print("OptionsType.Slider e:$e, currentTime:$currentTime");
        if (e.value == currentTime) {
          _currentLyricIndex = e.key;
          // _simulatePlayback();
        }
      }).toList();
    }
    // else {
    if (currentTime == 0 && _currentLyricIndex == _lyrics.length - 1) {
      _currentLyricIndex = 0;
    }
    if (_currentLyricIndex + 1 < _lyrics.length &&
        _lyrics[_currentLyricIndex + 1].time == currentTime) {
      _simulatePlayback();
    }
    // }
  }

  Future<dynamic> getLrc(String url, ValueChanged callback) async {
    await Utils.get(url, null).then((res) {
      callback.call(res);
    });
  }

  void _simulatePlayback() async {
    if (_currentLyricIndex < _lyrics.length - 1) {
      if (mounted) {
        setState(() {
          _currentLyricIndex++;
          _scrollToCurrentLyric();
        });
      }
    }
    //}
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

  @override
  Widget build(BuildContext context) {
    return _buildLyricsList();
  }
}
