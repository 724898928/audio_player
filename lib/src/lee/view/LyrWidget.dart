import 'dart:collection';

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
    String? url,
    int currentTime,
  ) async {
    await lyrWidgetState.update(url, currentTime);
  }

  Future<void> clear() async {
    await lyrWidgetState.clear();
  }
}

class _LyrWidgetState extends State<LyrWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentLyricIndex = 0;
  String? lrcUrl = null;

  late LinkedHashMap<int, List<Lyric>>? _lyrics = null;
  late double myHeight = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> clear() async {
    setState(() {
      _lyrics = null;
      lrcUrl = null;
      _currentLyricIndex = 0;
    });
  }

  Future<void> update(
    String? url,
    int currentTime,
  ) async {
    print("update url: $url , currenttime: $currentTime");
    if (lrcUrl != url) {
      lrcUrl = url;
      await getLrc(url!, (res) {
        if (null != res) {
          print("update res: $res");
          _lyrics = LyricParser.parse(res);
        }
        setState(() {});
      });
    }
    _simulatePlayback(currentTime);
  }

  Future<dynamic> getLrc(String url, ValueChanged callback) async {
    await Utils.get(url, null).then((res) {
      callback.call(res);
    });
  }

  void _simulatePlayback(int currentTime) async {
    if (null != _lyrics && _currentLyricIndex < _lyrics!.length - 1) {
      var tmp = _lyrics!.keys.toList().indexOf(currentTime);
      _currentLyricIndex = -1 == tmp ? _currentLyricIndex : tmp;
      if (mounted) {
        setState(() {
          _scrollToCurrentLyric();
        });
      }
    }
  }

  void _scrollToCurrentLyric() {
    final double itemHeight = 47;
    final double targetPosition = _currentLyricIndex * itemHeight;
    _scrollController.animateTo(
      targetPosition - (myHeight / 2 - 2 * itemHeight),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildLyricsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(20),
      itemCount: _lyrics?.length ?? 0,
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
              child: Text(_lyrics?.values.elementAt(index).first.text ?? ""),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      myHeight = constraints.maxHeight;
      return _buildLyricsList();
    });
  }
}
