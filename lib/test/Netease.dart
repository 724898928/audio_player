import 'dart:convert';
import 'dart:math';
//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

var dio = Dio();
void main() async {
  String msg = "苹果香"; // replace with your search query
  int n = 0; // replace with your desired index
  String type = "song"; // or "songid", "random"
  int countLimit = 10;
  int pageLimit = 1;
  int offsetLimit = (pageLimit - 1) * countLimit;
  String id = "your_id"; // replace with your ID

  // switch (type) {
  //   case 'song':
  //     if (msg.isEmpty) {
  //       print(jsonEncode({'code': 200, 'text': '请输入要解析的歌名'}));
  //       return;
  //     }
  //     await getNeteaseSong(msg, offsetLimit, countLimit, n);
  //     break;
  //   case 'songid':
  //     if (id.isNotEmpty) {
  //       String songUrl = 'http://music.163.com/song/media/outer/url?id=$id';
  //       songUrl = await getRedirectUrl(songUrl);
  //       print(jsonEncode({
  //         'code': 200,
  //         'text': '解析成功',
  //         'type': '歌曲解析',
  //         'now': DateTime.now().toString(),
  //         'song_url': songUrl
  //       }));
  //     } else {
  //       print(jsonEncode(
  //           {'code': 200, 'text': '解析失败，请检 查歌曲id值是否正确', 'type': '歌曲解析'}));
  //     }
  //     break;
  //   case 'random':
  //     var albumData = await getAlbumSongs(id);
  //     getRandomSong(albumData);
  //     break;
  //   default:
  //     print(jsonEncode({'code': 200, 'text': '请求参数不存在$type'}));
  // }
}

Future<void> getNeteaseSong(
    String msg, int offsetLimit, int countLimit, int n) async {
  String url =
      "https://s.music.163.com/search/get/?src=lofter&type=1&filterDj=false&limit=$countLimit&offset=$offsetLimit&s=${Uri.encodeComponent(msg)}";
  String jsonStr = await getCurl(url);
  Map<String, dynamic> jsonData = jsonDecode(jsonStr);
  List<dynamic> songList = jsonData['result']['songs'];
  List<Map<String, dynamic>> dataList = [];

  if (n != null) {
    var songInfo = songList[n];
    String songUrl =
        'http://music.163.com/song/media/outer/url?id=${songInfo['id']}';
    songUrl = await getRedirectUrl(songUrl);
    dataList.add({
      "id": songInfo['id'],
      "name": songInfo['name'],
      "singername": songInfo['artists'][0]['name'],
      "page": songInfo['page'],
      "song_url": songUrl
    });
  } else {
    for (var song in songList) {
      dataList.add({
        "id": song['id'],
        "name": song['name'],
        "singername": song['artists'][0]['name']
      });
    }
  }
  print(jsonEncode({
    'code': 200,
    'text': '解析成功',
    'type': '歌曲解析',
    'now': DateTime.now().toString(),
    'data': dataList
  }));
}

Future<void> getRandomSong(String albumData) async {
  Map<String, dynamic> jsonData = jsonDecode(albumData);
  var playlist = jsonData['playlist'];
  String id = playlist['id'];
  String name = playlist['name'];
  String description = playlist['description'];
  List<dynamic> trackIds = playlist['trackIds'];
  int randomNumber = Random().nextInt(trackIds.length);
  String randomId = trackIds[randomNumber]['id'];
  String songUrl = 'http://music.163.com/song/media/outer/url?id=$randomId';
  songUrl = await getRedirectUrl(songUrl);
  Map<String, dynamic> dataList = {
    "id": id,
    "album_name": name,
    "album_description": description,
    "song_id": randomId,
    "song_url": songUrl
  };
  print(jsonEncode({
    'code': 200,
    'text': '解析成功',
    'type': '歌单随机歌曲',
    'now': DateTime.now().toString(),
    'data': dataList
  }));
}

Future<String> getAlbumSongs(String id) async {
  id = id.isEmpty ? "3778678" : id;
  Map<String, String>? postData = {
    's': '100',
    'id': id,
    'n': '100',
    't': '100'
  };
  String url = "http://music.163.com/api/v6/playlist/detail";
  String jsonStr = await postCurl(url, postData);
  return jsonStr;
}

Future<String> getCurl(String url,
    {Map<String, String>? headers, String? cookies}) async {
  headers ??= {
    "User-Agent":
        "Mozilla/6.0 (Linux; Android 11; SAMSUNG SM-G973U) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/14.2 Chrome/87.0.4280.141 Mobile Safari/537.36"
  };
  var response = await dio.get(
    url,
    options: Options(headers: headers),
  );
  return response.data;
}

Future<String> postCurl(String postUrl, Map<String, dynamic>? postData,
    {Map<String, String>? headers, String? cookies}) async {
  headers ??= {
    "User-Agent":
        "Mozilla/6.0 (Linux; Android 11; SAMSUNG SM-G973U) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/14.2 Chrome/87.0.4280.141 Mobile Safari/537.36"
  };
  var response = await dio.post(postUrl,
      options: Options(headers: headers), queryParameters: postData);
  return response.data;
}

Future<String> getRedirectUrl(String url,
    {Map<String, String>? headers}) async {
  headers ??= {
    "User-Agent":
        "Mozilla/6.0 (Linux; Android 11; SAMSUNG SM-G973U) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/14.2 Chrome/87.0.4280.141 Mobile Safari/537.36"
  };
  var response = await dio.get(
    url,
    options: Options(headers: headers),
  );
  //return response.headers['location']!;
  return response.headers.map['location']!.toString();
}
