import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/material.dart';

import '../common/PlayUtils.dart';
import '../component/featureContext.dart';

class SongsListView extends StatefulWidget {
  SongsListView({super.key});
  _SongsListViewState favouriteState = _SongsListViewState();
  @override
  State<SongsListView> createState() => favouriteState;

  void updateView() {
    favouriteState.updateView();
  }
}

class _SongsListViewState extends State<SongsListView> {
  Songlist songs = Songlist.getInstance();

  void updateView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureContext(
        child: Card(
      child: ListView.builder(
          itemCount: songs.proPlaySongList.length,
          itemBuilder: (ctx, idx) {
            return TextButton(
                onPressed: () async {
                  // int id = songs.add(pSongs[idx]);
                  //  PlayStatus.getInstance().newPlayIdx = idx;
                  await PlayUtils.toPlay(idx: idx);
                },
                child: Text(
                    '${songs.proPlaySongList[idx].title} - ${songs.proPlaySongList[idx].artist}'));
          }),
    ));
  }
}
