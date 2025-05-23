import 'package:audio_player/src/lee/common/PlayStatus.dart';
import 'package:flutter/material.dart';

class LyrWidget extends StatefulWidget {
  LyrWidget({super.key});
  _LyrWidgetState lyrWidgetState = _LyrWidgetState();
  @override
  State<LyrWidget> createState() => lyrWidgetState;

  Future<void> update() async {
    await lyrWidgetState.update();
  }

}

class _LyrWidgetState extends State<LyrWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentLyricIndex = 0;
  late double myHeight = 0;
  PlayStatus playState = PlayStatus.getInstance();

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
    if (mounted) {
      setState(() {
        playState.setLyrics = null;
        playState.setCurrentlrcUrl = null;
        _currentLyricIndex = -1;
      });
    }
  }

  Future<void> update() async {
    print("update lyric widget");
    _simulatePlayback(currentTime: (playState.playTime!.inMilliseconds / 500).toInt());
  }

  void _simulatePlayback({int? currentTime}) async {
    if (null == currentTime) {
      return;
    }
    if (null != playState.lyrics && _currentLyricIndex < playState.lyrics!.length - 1) {
      var tmp = playState.lyrics!.keys.toList().indexOf(currentTime!);
      _currentLyricIndex = -1 == tmp ? _currentLyricIndex : tmp;

    }
    if (mounted) {
      setState(() {
        _scrollToCurrentLyric();
      });
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
      itemCount: playState.lyrics?.length ?? 0,
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
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  playState.lyrics?.values.elementAt(index).first.text ?? ""),
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
