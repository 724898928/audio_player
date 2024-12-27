import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:flutter/material.dart';

import 'Song.dart';

abstract class PlatformTools {
  dynamic doSearch();
  Future<dynamic> doGetSongs(String songName, int pageNo, int pageSize);
  String getPlatformUrl();
  String setPlatformUrl();
  Widget getWidget(BuildContext ctx, dynamic);
}

class MiGu implements PlatformTools {
  String songName = "";

  int pageNo = 1;

  int pageSize = 10;

  //无损 formatType=SQ resourceType=E   高品 formatType=HQ resourceType=2
  String formatType = 'HQ';
  dynamic resourceType = 2;

  String copyrightId = "";

  String contentId = "";

  String searchUrl =
      "https://pd.musicapp.migu.cn/MIGUM2.0/v1.0/content/search_all.do?&ua=Android_migu&version=5.0.1&text=漠河舞厅&pageNo=1&pageSize=10&searchSwitch={'song':1,'album':0,'singer':0,'tagSong':0,'mvSong':0,'songlist':0,'bestShow':1}";

  String playUrl =
      "https://app.pd.nf.migu.cn/MIGUM2.0/v1.0/content/sub/listenSong.do?toneFlag=E&netType=00&userId=15548614588710179085069&ua=Android_migu&version=5.1&copyrightId=69058500013&contentId=600929000001147576&resourceType=2&channel=0";

  String lyricUrl =
      "https://music.migu.cn/v3/api/music/audioPlayer/getLyric?copyrightId={copyrightId}";

  String songPicUrl =
      "https://music.migu.cn/v3/api/music/audioPlayer/getSongPic?songId={songId}";

  List<SearchSong> proSongList = [];

  MiGu setSearchUrl(String songName, int pageNo, int pageSize) {
    this.songName = songName;
    this.pageNo = pageNo;
    this.pageSize = pageSize;
    this.searchUrl =
        "https://pd.musicapp.migu.cn/MIGUM2.0/v1.0/content/search_all.do?&ua=Android_migu&version=5.0.1&text=$songName&pageNo=$pageNo&pageSize=$pageSize&searchSwitch={%22song%22:1,%22album%22:0,%22singer%22:0,%22tagSong%22:0,%22mvSong%22:0,%22songlist%22:0,%22bestShow%22:1}";
    return this;
  }

  MiGu setPlayUrl(
    String copyrightId,
    String contentId,
    dynamic resourceType,
  ) {
    this.copyrightId = copyrightId;
    this.contentId = contentId;
    this.resourceType = resourceType;
    this.playUrl =
        "https://app.pd.nf.migu.cn/MIGUM2.0/v1.0/content/sub/listenSong.do?toneFlag=E&netType=00&userId=15548614588710179085069&ua=Android_migu&version=5.1&copyrightId=${copyrightId}&contentId=${contentId}&resourceType=${resourceType}&channel=0";
    return this;
  }

  @override
  Future<MiGu> doGetSongs(String songName, int pageNo, int pageSize) async {
    print("doGetSongs songName :$songName");
    var migu = setSearchUrl(songName, pageNo, pageSize);
    Utils.hget(this.searchUrl).then((value) {
      //  print("value :$value \n");
      if (value != null) {
        var songs = value['songResultData']['result'];
        print("songs :$songs \n");
        if (songs != null) {
          songs.forEach((song) {
            var s = song as Map<String, dynamic>;
            print("song :$s \n");
            var proSong = SearchSong.fromJson(s);
            proSongList.add(proSong);
          });
        }
      }
    });
    return migu;
  }

  MiGu setLyricUrl(String copyrightId) {
    this.lyricUrl =
        "music.migu.cn/v3/api/music/audioPlayer/getLyric?copyrightId=${copyrightId}";
    return this;
  }

  MiGu setSongPicUrl(String songId) {
    this.songPicUrl =
        "music.migu.cn/v3/api/music/audioPlayer/getSongPic?songId=${songId}";
    return this;
  }

  @override
  String getPlatformUrl() {
    return 'https://www.migu.cn';
  }

  @override
  String setPlatformUrl() {
    return 'https://www.migu.cn';
  }

  @override
  doSearch() {
    // TODO: implement doSearch
    throw UnimplementedError();
  }

  @override
  Widget getWidget(ctx, dynamic) {
    return ListView.separated(
        itemBuilder: (context, idx) {
          return ElevatedButton(
              onPressed: () {
                Utils.showListDialog(ctx, proSongList, (idx) {
                  print("idx :$idx");
                });
              },
              child: Text(proSongList[idx].name ?? ""));
        },
        separatorBuilder: (ctx, idx) {
          return Divider();
        },
        itemCount: proSongList.length);
  }
}
