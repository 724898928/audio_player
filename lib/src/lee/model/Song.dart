import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/material.dart';

abstract class BaseSong {
  dynamic decodeMate(dynamic);
  dynamic dealSongMate(dynamic);
  Widget getWidget(BuildContext ctx, dynamic);
}

// 要播放的歌
class ProSong implements BaseSong {
  final String? id;
  final String? title;
  final String? artist;
  final String? album;
  final List<dynamic>? imgItems;
  final List<dynamic>? lyrics;
  late String? url;
  final String? year;
  final String? track;
  final String? genre;

  ProSong(
      {required this.id,
      required this.title,
      required this.artist,
      required this.album,
      required this.imgItems,
      required this.year,
      required this.track,
      required this.genre,
      required this.lyrics,
      required this.url});

  factory ProSong.fromJson(Map<String, dynamic> json, String? path) {
    return ProSong(
      id: json['id'],
      title: json['title'],
      artist: json['artist'] ?? 'Unknown',
      album: json['album'] ?? 'Unknown',
      imgItems: json['imgItems'],
      year: json['year']?.toString(),
      track: json['track']?.toString(),
      genre: json['genre']?.toString(),
      lyrics: json['lyrics'],
      url: json['url'] ?? path,
    );
  }

  void setUrl(String url) {
    this.url = url;
  }

  @override
  String toString() {
    return super.toString();
  }

  @override
  // TODO: implement hashCode
  int get hashCode {
    return id.hashCode +
        title.hashCode +
        artist.hashCode +
        album.hashCode +
        url.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProSong &&
        other.id == id &&
        other.title == title &&
        other.artist == artist &&
        other.album == album;
  }

  @override
  dealSongMate(dynamic) {
    // TODO: implement dealSongMate
    throw UnimplementedError();
  }

  @override
  decodeMate(dynamic) {
    // TODO: implement decodeMate
    throw UnimplementedError();
  }

  @override
  Widget getWidget(BuildContext ctx, dynamic) {
    // TODO: implement getWidget
    throw UnimplementedError();
  }
}

// 搜索到的歌
class SearchSong implements BaseSong {
  late bool? selected = false;
  final String? id;
  final String? name;
  final String? resourceType;
  final String? contentId;
  final String? copyrightId;
  final List<dynamic>? singers;
  final List<dynamic>? albums;
  final List<dynamic>? tags;
  final String? lyricUrl;
  final List<dynamic>? imgItems;
  final List<dynamic>? televisionNames;
  final List<dynamic>? tones;
  final List<dynamic>? relatedSongs;
  final String? toneControl;
  final List<dynamic>? rateFormats;
  final List<dynamic>? newRateFormats;
  final String? songType;
  final String? isInDAlbum;
  final String? digitalColumnId;
  final String? mrcurl;
  final String? songDescs;
  final String? invalidateDate;
  final String? isInSalesPeriod;
  final String? dalbumId;
  final String? isInSideDalbum;
  final String? vipType;
  final String? chargeAuditions;
  final String? scopeOfcopyright;
  late ProSong? proSong;

  set setSelected(bool value) {
    print("setSelected value: $value");
    this.selected = value;
  }

  get isSelected => this.selected;

  SearchSong({
    this.selected = false,
    required this.id,
    required this.name,
    required this.resourceType,
    required this.contentId,
    required this.copyrightId,
    required this.singers,
    required this.albums,
    required this.tags,
    required this.lyricUrl,
    required this.imgItems,
    required this.televisionNames,
    required this.tones,
    required this.relatedSongs,
    required this.toneControl,
    required this.rateFormats,
    required this.newRateFormats,
    required this.songType,
    required this.isInDAlbum,
    required this.digitalColumnId,
    required this.mrcurl,
    required this.songDescs,
    required this.invalidateDate,
    required this.isInSalesPeriod,
    required this.dalbumId,
    required this.isInSideDalbum,
    required this.vipType,
    required this.chargeAuditions,
    required this.scopeOfcopyright,
  }) {
    proSong = ProSong(
      id: id,
      title: name,
      artist: singers?.last['name'],
      album: albums?.last['name'],
      lyrics: [lyricUrl],
      url: null,
      imgItems: imgItems,
      year: 'Unknown Year',
      track: 'Unknown Track',
      genre: 'Unknown Genre',
    );
  }

  factory SearchSong.fromJson(Map<String, dynamic> json) {
    return SearchSong(
        selected: false,
        id: json['id'],
        name: json['name'],
        resourceType: json['resourceType'],
        contentId: json['contentId'],
        copyrightId: json['copyrightId'],
        singers: json['singers'],
        albums: json['albums'],
        tags: json['tags'],
        lyricUrl: json['lyricUrl'],
        imgItems: json['imgItems'],
        televisionNames: json['televisionNames'],
        tones: json['tones'],
        relatedSongs: json['relatedSongs'],
        toneControl: json['toneControl'],
        rateFormats: json['rateFormats'],
        newRateFormats: json['newRateFormats'],
        songType: json['songType'],
        isInDAlbum: json['isInDAlbum'],
        digitalColumnId: json['digitalColumnId'],
        mrcurl: json['mrcurl'],
        songDescs: json['songDescs'],
        invalidateDate: json['invalidateDate'],
        isInSalesPeriod: json['isInSalesPeriod'],
        dalbumId: json['dalbumId'],
        isInSideDalbum: json['isInSideDalbum'],
        vipType: json['vipType'],
        chargeAuditions: json['chargeAuditions'],
        scopeOfcopyright: json['scopeOfcopyright']);
  }

  void getPlaySong() {
    var playUrl =
        "https://app.pd.nf.migu.cn/MIGUM2.0/v1.0/content/sub/listenSong.do?toneFlag=E&netType=00&userId=15548614588710179085069&ua=Android_migu&version=5.1&copyrightId=${copyrightId}&contentId=${contentId}&resourceType=${resourceType}&channel=0";
    var song = Songlist.getInstance();
    proSong!.setUrl(playUrl);
    song.add(proSong!);
  }

  void removeSong() {
    // var playUrl =
    //     "https://app.pd.nf.migu.cn/MIGUM2.0/v1.0/content/sub/listenSong.do?toneFlag=E&netType=00&userId=15548614588710179085069&ua=Android_migu&version=5.1&copyrightId=${copyrightId}&contentId=${contentId}&resourceType=${resourceType}&channel=0";
    var song = Songlist.getInstance();
    song.remove(proSong!);
  }

  @override
  dealSongMate(dynamic) {
    // TODO: implement dealSongMate
    throw UnimplementedError();
  }

  @override
  decodeMate(dynamic) {
    // TODO: implement decodeMate
    throw UnimplementedError();
  }

  @override
  Widget getWidget(BuildContext ctx, dynamic) {
    // TODO: implement getWidget
    throw UnimplementedError();
  }
}
/**
 * {
    "code": "000000",
    "info": "成功",
    "songResultData": {
        "totalCount": "4",
        "correct": [],
        "resultType": "2",
        "isFromCache": "0",
        "result": [
            {
                "id": "1139530271",
                "resourceType": "2",
                "contentId": "600929000001147576",
                "copyrightId": "69058500013",
                "name": "苹果香",
                "highlightStr": [
                    "苹果香"
                ],
                "singers": [
                    {
                        "id": "1106631212",
                        "name": "狼戈"
                    }
                ],
                "albums": [
                    {
                        "id": "1140924893",
                        "name": "苹果香",
                        "type": "1"
                    }
                ],
                "tags": [
                    "怀旧",
                    "原创",
                    "夜晚",
                    "录音室版",
                    "累积播放10w至999999",
                    "每周新增评论top10",
                    "累积收藏1000至9999",
                    "流行",
                    "国语",
                    "原创单曲",
                    "每日播放5000至1w"
                ],
                "lyricUrl": "https://d.musicapp.migu.cn/data/oss/resource/00/48/sm/e85ab54dd6f1400fa05aedf2f851c168",
                "trcUrl": "",
                "imgItems": [
                    {
                        "imgSizeType": "01",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/49/1v/c5df1760e73c4b3ea19355fea060f662.webp"
                    },
                    {
                        "imgSizeType": "02",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/49/1v/7fcc8ecf1e474d3daa0cb3de5b046e60.webp"
                    },
                    {
                        "imgSizeType": "03",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/49/1v/0630e1a4e39745908d7f6c2a913c1809.webp"
                    }
                ],
                "televisionNames": [
                    ""
                ],
                "tones": [
                    {
                        "id": "600929000001147574",
                        "copyrightId": "69058500013",
                        "price": "0",
                        "expireDate": "2025-10-18"
                    }
                ],
                "relatedSongs": [
                    {
                        "resourceType": "E",
                        "resourceTypeName": "无损",
                        "copyrightId": "69058500013",
                        "productId": "600929000001147576"
                    },
                    {
                        "resourceType": "1",
                        "resourceTypeName": "振铃",
                        "copyrightId": "69058500013",
                        "productId": "600929000001147575"
                    },
                    {
                        "resourceType": "0",
                        "resourceTypeName": "彩铃",
                        "copyrightId": "69058500013",
                        "productId": "600929000001147574"
                    },
                    {
                        "resourceType": "3",
                        "resourceTypeName": "随身听",
                        "copyrightId": "69058500013",
                        "productId": "600929000001147577"
                    }
                ],
                "toneControl": "111100",
                "rateFormats": [
                    {
                        "resourceType": "3",
                        "formatType": "LQ",
                        "format": "000019",
                        "size": "1807756",
                        "fileType": "mp3",
                        "price": "0"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "3615140",
                        "fileType": "mp3",
                        "price": "0"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "9037533",
                        "fileType": "mp3",
                        "price": "0"
                    },
                    {
                        "resourceType": "E",
                        "formatType": "SQ",
                        "format": "011002",
                        "size": "24545919",
                        "price": "0",
                        "androidFileType": "flac",
                        "iosFileType": "m4a",
                        "iosSize": "25025920",
                        "androidSize": "24545919",
                        "iosFormat": "011003",
                        "androidFormat": "011002",
                        "iosAccuracyLevel": "16bit",
                        "androidAccuracyLevel": "16bit"
                    }
                ],
                "newRateFormats": [
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "3615140",
                        "fileType": "mp3",
                        "price": "0"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "9037533",
                        "fileType": "mp3",
                        "price": "0"
                    },
                    {
                        "resourceType": "E",
                        "formatType": "SQ",
                        "format": "011002",
                        "size": "24545919",
                        "price": "0",
                        "androidFileType": "flac",
                        "iosFileType": "m4a",
                        "iosSize": "25025920",
                        "androidSize": "24545919",
                        "iosFormat": "011003",
                        "androidFormat": "011002",
                        "iosAccuracyLevel": "16bit",
                        "androidAccuracyLevel": "16bit"
                    }
                ],
                "songType": "",
                "isInDAlbum": "0",
                "copyright": "1",
                "digitalColumnId": "",
                "mrcurl": "https://d.musicapp.migu.cn/data/oss/resource/00/48/rj/2e2b4b1bc5384b4cbe9f6da8dfb1ae78",
                "songDescs": "",
                "invalidateDate": "2025-10-18",
                "isInSalesPeriod": "0",
                "dalbumId": "",
                "isInSideDalbum": "0",
                "vipType": "",
                "chargeAuditions": "0",
                "scopeOfcopyright": "01"
            },
            {
                "id": "1140727688",
                "resourceType": "2",
                "contentId": "600929000000637747",
                "copyrightId": "63250300290",
                "name": "苹果香（黑大婶版）",
                "highlightStr": [
                    "苹果香"
                ],
                "singers": [
                    {
                        "id": "1140727685",
                        "name": "黑大婶回乡带娃"
                    }
                ],
                "albums": [
                    {
                        "id": "1140727686",
                        "name": "苹果香（黑大婶版）",
                        "type": "1"
                    }
                ],
                "tags": [
                    "流行",
                    "国语",
                    "每日播放1000至4999",
                    "录音室版",
                    "怀旧",
                    "驾车",
                    "累积播放10w至999999",
                    "累积收藏1000至9999"
                ],
                "lyricUrl": "https://d.musicapp.migu.cn/data/oss/resource/00/44/mv/7e5556087c0d439c9b32f7b3fe0e48b9",
                "trcUrl": "",
                "imgItems": [
                    {
                        "imgSizeType": "01",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/42/u0/6887a78bb7a949fdaf0154ce65239e71.webp"
                    },
                    {
                        "imgSizeType": "02",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/42/u0/45811096df9749e0b24f68ec408d577e.webp"
                    },
                    {
                        "imgSizeType": "03",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/42/u0/b6db10f80ae242b186247d3f4fb5f5a7.webp"
                    }
                ],
                "televisionNames": [
                    ""
                ],
                "tones": [
                    {
                        "id": "600929000000637745",
                        "copyrightId": "63250300290",
                        "price": "200",
                        "expireDate": "2026-07-16"
                    }
                ],
                "relatedSongs": [
                    {
                        "resourceType": "1",
                        "resourceTypeName": "振铃",
                        "copyrightId": "63250300290",
                        "productId": "600929000000637746"
                    },
                    {
                        "resourceType": "0",
                        "resourceTypeName": "彩铃",
                        "copyrightId": "63250300290",
                        "productId": "600929000000637745"
                    },
                    {
                        "resourceType": "3",
                        "resourceTypeName": "随身听",
                        "copyrightId": "63250300290",
                        "productId": "600929000000637748"
                    }
                ],
                "toneControl": "110000",
                "rateFormats": [
                    {
                        "resourceType": "3",
                        "formatType": "LQ",
                        "format": "000019",
                        "size": "170818",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "341264",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "852846",
                        "fileType": "mp3",
                        "price": "200"
                    }
                ],
                "newRateFormats": [
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "341264",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "852846",
                        "fileType": "mp3",
                        "price": "200"
                    }
                ],
                "songType": "",
                "isInDAlbum": "0",
                "copyright": "1",
                "digitalColumnId": "",
                "mrcurl": "https://d.musicapp.migu.cn/data/oss/resource/00/44/mv/de4c41ec8cb642dda6fd126819ec1c04",
                "songDescs": "",
                "invalidateDate": "2026-07-16",
                "isInSalesPeriod": "0",
                "dalbumId": "",
                "isInSideDalbum": "0",
                "vipType": "",
                "chargeAuditions": "0",
                "scopeOfcopyright": "01"
            },
            {
                "id": "1141005234",
                "resourceType": "2",
                "contentId": "600929000001871528",
                "copyrightId": "69045701290",
                "name": "搞笑版苹果香了",
                "highlightStr": [
                    "苹果香"
                ],
                "singers": [
                    {
                        "id": "1001950867",
                        "name": "小泳"
                    }
                ],
                "tags": [
                    "流行",
                    "国语"
                ],
                "lyricUrl": "https://d.musicapp.migu.cn/data/oss/resource/00/4a/vt/f2cc6c14bc944d648f39009e91fcf758",
                "trcUrl": "",
                "imgItems": [
                    {
                        "imgSizeType": "01",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/47/90/d70e4f5472d64f99a5a826b8478a9b32.webp"
                    },
                    {
                        "imgSizeType": "02",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/47/90/f5fc4661c63c4206be631d3b82d3b86d.webp"
                    },
                    {
                        "imgSizeType": "03",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/47/90/e959bd5195804520b0a88c5e86863f7f.webp"
                    }
                ],
                "televisionNames": [
                    ""
                ],
                "tones": [
                    {
                        "id": "600929000001871526",
                        "copyrightId": "69045701290",
                        "price": "200",
                        "expireDate": "2026-09-28"
                    }
                ],
                "relatedSongs": [
                    {
                        "resourceType": "1",
                        "resourceTypeName": "振铃",
                        "copyrightId": "69045701290",
                        "productId": "600929000001871527"
                    },
                    {
                        "resourceType": "0",
                        "resourceTypeName": "彩铃",
                        "copyrightId": "69045701290",
                        "productId": "600929000001871526"
                    },
                    {
                        "resourceType": "3",
                        "resourceTypeName": "随身听",
                        "copyrightId": "69045701290",
                        "productId": "600929000001871529"
                    }
                ],
                "toneControl": "110000",
                "rateFormats": [
                    {
                        "resourceType": "3",
                        "formatType": "LQ",
                        "format": "000019",
                        "size": "253156",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "505940",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "1264536",
                        "fileType": "mp3",
                        "price": "200"
                    }
                ],
                "newRateFormats": [
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "505940",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "1264536",
                        "fileType": "mp3",
                        "price": "200"
                    }
                ],
                "songType": "",
                "isInDAlbum": "0",
                "copyright": "1",
                "digitalColumnId": "",
                "mrcurl": "",
                "songDescs": "",
                "invalidateDate": "2026-09-28",
                "isInSalesPeriod": "0",
                "dalbumId": "",
                "isInSideDalbum": "0",
                "vipType": "",
                "chargeAuditions": "0",
                "scopeOfcopyright": "01"
            },
            {
                "id": "1004383818",
                "resourceType": "2",
                "contentId": "600908000003370340",
                "copyrightId": "60073231456",
                "name": "青苹果香气",
                "highlightStr": [
                    "苹果香"
                ],
                "singers": [
                    {
                        "id": "1004386236",
                        "name": "Rabbit Hole"
                    }
                ],
                "albums": [
                    {
                        "id": "1004446902",
                        "name": "Rabbit Hole The 1st",
                        "type": "1"
                    }
                ],
                "tags": [
                    "录音室版",
                    "韩语",
                    "流行",
                    "爱情",
                    "驾车",
                    "幸福"
                ],
                "lyricUrl": "https://d.musicapp.migu.cn/data/oss/resource/00/2j/ap/vb",
                "trcUrl": "",
                "imgItems": [
                    {
                        "imgSizeType": "01",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/2t/pp/8b00116d23674f638cf9274a395e2638.webp"
                    },
                    {
                        "imgSizeType": "02",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/2t/pp/016b79d453c445df87e8575a8d555091.webp"
                    },
                    {
                        "imgSizeType": "03",
                        "img": "https://d.musicapp.migu.cn/data/oss/resource/00/2t/pp/031e4d71221d49d799cbb3d5c3bb48e6.webp"
                    }
                ],
                "televisionNames": [
                    ""
                ],
                "tones": [
                    {
                        "id": "600908000003370338",
                        "copyrightId": "60073231456",
                        "price": "200",
                        "expireDate": "2026-09-30"
                    }
                ],
                "relatedSongs": [
                    {
                        "resourceType": "E",
                        "resourceTypeName": "无损",
                        "copyrightId": "60073231456",
                        "productId": "600908000003370340"
                    },
                    {
                        "resourceType": "1",
                        "resourceTypeName": "振铃",
                        "copyrightId": "60073231456",
                        "productId": "600908000003370339"
                    },
                    {
                        "resourceType": "0",
                        "resourceTypeName": "彩铃",
                        "copyrightId": "60073231456",
                        "productId": "600908000003370338"
                    },
                    {
                        "resourceType": "3",
                        "resourceTypeName": "随身听",
                        "copyrightId": "60073231456",
                        "productId": "600908000003370341"
                    }
                ],
                "toneControl": "111100",
                "rateFormats": [
                    {
                        "resourceType": "3",
                        "formatType": "LQ",
                        "format": "000019",
                        "size": "1997928",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "3999494",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "9992402",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "E",
                        "formatType": "SQ",
                        "format": "011002",
                        "size": "30795403",
                        "price": "200",
                        "androidFileType": "flac",
                        "iosFileType": "m4a",
                        "iosSize": "31058924",
                        "androidSize": "30795403",
                        "iosFormat": "011003",
                        "androidFormat": "011002",
                        "iosAccuracyLevel": "16bit",
                        "androidAccuracyLevel": "16bit"
                    }
                ],
                "newRateFormats": [
                    {
                        "resourceType": "2",
                        "formatType": "PQ",
                        "format": "020007",
                        "size": "3999494",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "2",
                        "formatType": "HQ",
                        "format": "020010",
                        "size": "9992402",
                        "fileType": "mp3",
                        "price": "200"
                    },
                    {
                        "resourceType": "E",
                        "formatType": "SQ",
                        "format": "011002",
                        "size": "30795403",
                        "price": "200",
                        "androidFileType": "flac",
                        "iosFileType": "m4a",
                        "iosSize": "31058924",
                        "androidSize": "30795403",
                        "iosFormat": "011003",
                        "androidFormat": "011002",
                        "iosAccuracyLevel": "16bit",
                        "androidAccuracyLevel": "16bit"
                    }
                ],
                "songType": "",
                "isInDAlbum": "0",
                "copyright": "1",
                "digitalColumnId": "",
                "mrcurl": "",
                "songDescs": "",
                "songAliasName": "풋사과 향기",
                "translateName": "",
                "invalidateDate": "2026-09-30",
                "isInSalesPeriod": "0",
                "dalbumId": "",
                "isInSideDalbum": "0",
                "vipType": "",
                "chargeAuditions": "0",
                "scopeOfcopyright": "01"
            }
        ],
        "tipStatus": "0"
    },
    "bestShowResultData": {
        "total": "0"
    },
    "liveConcertResultData": {},
    "bestShowResultToneData": {}
}
 * 
 */
