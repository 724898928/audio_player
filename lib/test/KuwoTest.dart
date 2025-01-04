import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

var dio = Dio();
// 关键字搜索
// `http://www.kuwo.cn/api/www/search/searchKey?key=${key}&httpsStatus=1`

// 单曲搜索
// `http://www.kuwo.cn/api/www/search/searchMusicBykeyWord?key=${key}&pn=${pn}&rn=${rn}&httpsStatus=1`

// 专辑搜索
// `http://www.kuwo.cn/api/www/search/searchAlbumBykeyWord?key=${key}&pn=${pn}&rn=${rn}&httpsStatus=1`

// mv 搜索
// `http://www.kuwo.cn/api/www/search/searchMvBykeyWord?key=${key}&pn=${pn}&rn=${rn}&httpsStatus=1`

// 歌单搜索
//`http://www.kuwo.cn/api/www/search/searchPlayListBykeyWord?key=${key}&pn=${pn}&rn=${rn}&httpsStatus=1`

// 歌手搜索
// `http://www.kuwo.cn/api/www/search/searchArtistBykeyWord?key=${key}&pn=${pn}&rn=${rn}&httpsStatus=1`
void main() async {
  String msg = "苹果香"; // replace with your search query
  int n = 5; // replace with your desired index
  String type = "song"; // or "mv", "rid", "mid"
  int pageLimit = 1;
  int countLimit = 20;
  await getKuwoSong(msg, pageLimit, countLimit, n);
  // switch (type) {
  //   case '':
  //     print(jsonEncode({'code': 200, 'text': '解析失败，请输入要解析的歌曲或者MV名称'}));
  //     break;
  //   case 'mv':
  //     var dataList = await getKuwoMv(msg, pageLimit, countLimit, n);
  //     print(jsonEncode({
  //       'code': 200,
  //       'text': '解析成功',
  //       'type': 'MV解析',
  //       'now': DateTime.now().toString(),
  //       'data': dataList
  //     }));
  //     break;
  //   case 'song':
  //     await getKuwoSong(msg, pageLimit, countLimit, n);
  //     break;
  //   case 'rid':
  //     String id = "your_id"; // replace with your ID
  //     if (id.isNotEmpty) {
  //       var songData = await getMp3Data(id);
  //       print(jsonEncode(songData));
  //     } else {
  //       print(jsonEncode(
  //           {'code': 200, 'text': '解析失败，请检查歌曲rid值是否正确', 'type': '歌曲解析'}));
  //     }
  //     break;
  //   case 'mid':
  //     String id = "your_id"; // replace with your ID
  //     if (id.isNotEmpty) {
  //       var mvData = await getMvData(id);
  //       if (mvData != null) {
  //         print(jsonEncode(mvData));
  //       } else {
  //         print(jsonEncode(
  //             {'code': 200, 'text': '解析失败，请检查MV mid值是否正确', 'type': 'MV解析'}));
  //       }
  //     }
  //     break;
  //   default:
  //     print(jsonEncode({'code': 200, 'text': '请求参数不存在'}));
  // }
}

Future<void> getKuwoSong(
    String msg, int pageLimit, int countLimit, int n) async {
  // String url =
  //     "http://www.kuwo.cn/api/www/search/searchKey?key=${Uri.encodeComponent(msg)}&pn=$pageLimit&rn=$countLimit&httpsStatus=1";

  String url =
      "http://search.kuwo.cn/r.s?all=${msg}&ft=music&itemset=web_2013&client=kt&pn=${pageLimit}&rn=${pageLimit}&rformat=json&encoding=utf8";

  Map<String, dynamic> jsonData = await getCurl(url);

  // List<dynamic> infoList = jsonData['data']['list'];
  List<Map<String, dynamic>> dataList = [];
  if (n != null) {
    //  var info = infoList[n];
    String songRid = jsonData['reqId'];
    String? songUrl;
    if (songRid.isNotEmpty) {
      var jsonData2 = await getMp3Data(songRid);
      print("jsonData2: $jsonData2");
      songUrl = jsonData2['data'] == null
          ? "付费歌曲暂时无法获取歌曲下载链接"
          : jsonData2['data']['url'];
    }

    // dataList.add({
    //   "name": info['name'],
    //   "singername": info['artist'],
    //   "duration":
    //       Duration(seconds: info['duration']).toString().split('.').first,
    //   "file_size": null,
    //   "song_url": songUrl ?? "",
    //   "mv_url": (await getMvData(songRid))['data']['url'],
    //   "album_img": info['pic'],
    // });
  } else {
    // for (var info in infoList) {
    //   dataList.add({
    //     "name": info['name'],
    //     "singername": info['artist'],
    //     "duration":
    //         Duration(seconds: info['duration']).toString().split('.').first,
    //     "rid": info['rid'],
    //   });
    // }
  }
  print(jsonEncode({
    'code': 200,
    'text': '解析成功',
    'type': '歌曲解析',
    'now': DateTime.now().toString(),
    'data': dataList
  }));
}

Future<List<Map<String, dynamic>>> getKuwoMv(
    String msg, int pageLimit, int countLimit, int n) async {
  String url =
      "http://www.kuwo.cn/api/www/search/searchMvBykeyWord?key=${Uri.encodeComponent(msg)}&pn=$pageLimit&rn=$countLimit&httpsStatus=1";

  Map<String, dynamic> jsonData = await getCurl(url);

  List<dynamic> infoList = jsonData['data']['mvlist'];
  List<Map<String, dynamic>> dataList = [];
  if (n != null) {
    var info = infoList[n];
    var jsonData2 = await getMvData(info['id']);
    String mvUrl = jsonData2['data']['url'];

    dataList.add({
      "name": info['name'],
      "singername": info['artist'],
      "duration":
          Duration(seconds: info['duration']).toString().split('.').first,
      "file_size": null,
      "mv_url": mvUrl,
      "cover_url": info['pic'],
      "publish_date": null,
    });
  } else {
    for (var info in infoList) {
      dataList.add({
        "name": info['name'],
        "singername": info['artist'],
        "duration":
            Duration(seconds: info['duration']).toString().split('.').first,
        "cover_url": info['pic'],
      });
    }
  }
  return dataList;
}

//http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=MUSIC_167906908&format=aac|mp3&response=url
// http://kuwo.cn/api/v1/www/music/playUrl?mid=df9a98c15f9ccc00fb0f118f1435bebd&type=music&httpsStatus=1
Future<Map<String, dynamic>> getMp3Data(String songRid) async {
  String url =
      'http://www.kuwo.cn/api/v1/www/music/playUrl?mid=$songRid&type=music&httpsStatus=1';
  Map<String, dynamic> jsonStr = await getCurl(url);
  return jsonStr;
}

Future<Map<String, dynamic>> getMvData(String mvMid) async {
  String url =
      'http://www.kuwo.cn/api/v1/www/music/playUrl?mid=$mvMid&type=mv&httpsStatus=1';
  Map<String, dynamic> jsonStr = await getCurl(url);
  return jsonStr;
}

Future<Map<String, dynamic>> getCurl(String url) async {
  var response = await dio.get(
    url,
    options: Options(
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0',
        'Accept': 'application/json, text/plain, */*',
        'Referer': 'https://www.kuwo.cn',
        'Secret':
            '10373b58aee58943f95eaf17d38bc9cf50fbbef8e4bf4ec6401a3ae3ef8154560507f032',
        'Cookie':
            'Hm_lvt_cdb524f42f0ce19b169a8071123a4797=1687520303,1689840209; _ga=GA1.2.2021483490.1666455184; _ga_ETPBRPM9ML=GS1.2.1689840210.4.1.1689840304.60.0.0; Hm_Iuvt_cdb524f42f0ce19b169b8072123...',
      },
    ),
  );
  print("response.data: ${response.data}");
  return response.data;
}
