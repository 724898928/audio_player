import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

Future<void> main() async {
  await getKugouSong("墨尔本的秋天", 1, 10, '9');

  // final request = HttpRequest();

  // final msg = request.uri.queryParameters['msg']; // 需要搜索的歌名
  // final n = request.uri.queryParameters['n']; // 选择(序号)
  // final type = request.uri.queryParameters['type'] ?? 'song';
  // final pageLimit =
  //     int.tryParse(request.uri.queryParameters['page'] ?? '1') ?? 1;
  // final countLimit =
  //     int.tryParse(request.uri.queryParameters['count'] ?? '10') ?? 10;

  // switch (type) {
  //   case '':
  //     request.response
  //       ..statusCode = HttpStatus.ok
  //       ..headers.contentType = ContentType.json
  //       ..write(jsonEncode({'code': 200, 'text': '解析失败，请输入要解析的歌名'}));
  //     break;
  //   case 'mv':
  //     final dataList = await getKugouMv(msg!, pageLimit, countLimit, n!);
  //     request.response
  //       ..statusCode = HttpStatus.ok
  //       ..headers.contentType = ContentType.json
  //       ..write(jsonEncode({
  //         'code': 200,
  //         'text': '解析成功',
  //         'type': 'MV解析',
  //         'now': DateTime.now().toString(),
  //         'data': dataList
  //       }));
  //     break;
  //   case 'song':
  //     await getKugouSong(request, msg!, pageLimit, countLimit, n!);
  //     break;
  //   case 'shash':
  //     if (request.uri.queryParameters['hash'] != null) {
  //       final songData = await getMp3Data(request.uri.queryParameters['hash']!);
  //       request.response
  //         ..statusCode = HttpStatus.ok
  //         ..headers.contentType = ContentType.json
  //         ..write(jsonEncode(songData));
  //     } else {
  //       request.response
  //         ..statusCode = HttpStatus.ok
  //         ..headers.contentType = ContentType.json
  //         ..write(jsonEncode(
  //             {'code': 200, 'text': '解析失败, 请检查歌曲hash值是否正确', 'type': '歌曲解析'}));
  //     }
  //     break;
  //   case 'mhash':
  //     if (request.uri.queryParameters['hash'] != null) {
  //       final mvData = await getMvData(request.uri.queryParameters['hash']!);
  //       if (mvData.isNotEmpty) {
  //         request.response
  //           ..statusCode = HttpStatus.ok
  //           ..headers.contentType = ContentType.json
  //           ..write(jsonEncode(mvData));
  //       }
  //     } else {
  //       request.response
  //         ..statusCode = HttpStatus.ok
  //         ..headers.contentType = ContentType.json
  //         ..write(jsonEncode(
  //             {'code': 200, 'text': '解析失败，请检查MV hash值是否正确', 'type': 'MV解析'}));
  //     }
  //     break;
  //   default:
  //     request.response
  //       ..statusCode = HttpStatus.ok
  //       ..headers.contentType = ContentType.json
  //       ..write(jsonEncode({'code': 200, 'text': '请求参数不存在'}));
  // }
}

Future<List<Map<String, dynamic>>> getKugouMv(
    String msg, int pageLimit, int countLimit, String n) async {
  final dio = Dio();
  final url =
      "https://mobiles.kugou.com/api/v3/search/mv?format=json&keyword=${Uri.encodeComponent(msg)}&page=$pageLimit&pagesize=$countLimit&showtype=1";
  final response = await dio.get(url);

  final jsonData = jsonDecode(response.data);
  final infoList = jsonData['data']['info'];
  final dataList = <Map<String, dynamic>>[];

  if (n.isNotEmpty) {
    final info = infoList[int.parse(n)];
    final jsonData2 = await getMvData(info['hash']);
    final mvdataList = jsonData2['mvdata'];

    var mvdata;
    if (mvdataList.containsKey('sq')) {
      mvdata = mvdataList['sq'];
    } else if (mvdataList.containsKey('le')) {
      mvdata = mvdataList['le'];
    } else if (mvdataList.containsKey('rq')) {
      mvdata = mvdataList['rq'];
    }

    dataList.add({
      'name': info['filename'],
      'singername': info['singername'],
      'duration': _formatDuration(info['duration']),
      'file_size': _formatFileSize(mvdata['filesize'] ?? 0),
      'play_count': jsonData['play_count'],
      'like_count': jsonData['like_count'],
      'comment_count': jsonData['comment_count'],
      'collect_count': jsonData['collect_count'],
      'mv_url': mvdata['downurl'],
      'cover_url': info['imgurl'].replaceAll('/{size}', ''),
      'publish_date': jsonData['publish_date']
    });
  } else {
    for (var info in infoList) {
      dataList.add({
        'name': info['filename'],
        'singername': info['singername'],
        'duration': _formatDuration(info['duration']),
        'cover_url': info['imgurl'].replaceAll('/{size}', '')
      });
    }
  }
  return dataList;
}

Future<void> getKugouSong(
    //HttpRequest request,
    String msg,
    int pageLimit,
    int countLimit,
    String n) async {
  final dio = Dio();
  final url =
      "https://mobiles.kugou.com/api/v3/search/song?format=json&keyword=${Uri.encodeComponent(msg)}&page=$pageLimit&pagesize=$countLimit&showtype=1";
  final response = await dio.get(url);
  final jsonData = jsonDecode(response.data);
  print("jsonData['data'] : ${jsonData['data']}");

  final infoList = jsonData['data']['info'];
  final dataList = <Map<String, dynamic>>[];

  if (n.isNotEmpty) {
    final info = infoList[int.parse(n)];

    final songHash = info['hash'];

    if (songHash.isNotEmpty) {
      final jsonData2 = await getMp3Data(songHash);
      final songUrl =
          jsonData2['error'] == null ? jsonData2['url'] : "付费歌曲暂时无法获取歌曲下载链接";

      dataList.add({
        'name': info['filename'],
        'singername': info['singername'],
        'duration': _formatDuration(info['duration']),
        'file_size': _formatFileSize(jsonData2['fileSize']),
        'song_url': songUrl,
        'mv_url': (await getKugouMv(msg, pageLimit, countLimit, n))[0]
            ['mv_url'],
        'album_img': jsonData2['album_img'].replaceAll('/{size}', '')
      });
    }
  } else {
    for (var info in infoList) {
      dataList.add({
        'name': info['filename'],
        'singername': info['singername'],
        'duration': _formatDuration(info['duration']),
        'hash': info['hash'],
        'mvhash': info['mvhash'] ?? null
      });
    }
  }
  print("dataList: $dataList");
  // request.response
  //   ..statusCode = HttpStatus.ok
  //   ..headers.contentType = ContentType.json
  //   ..write(jsonEncode({
  //     'code': 200,
  //     'text': '解析成功',
  //     'type': '歌曲解析',
  //     'now': DateTime.now().toString(),
  //     'data': dataList
  //   }));
}

// https://m.kugou.com/app/i/getSongInfo.php?hash=51db54fdd7d62228935002f2ba5afd87&cmd=playInfo
Future<Map<String, dynamic>> getMp3Data(String songHash) async {
  final dio = Dio();
  final url =
      'https://m.kugou.com/app/i/getSongInfo.php?hash=$songHash&cmd=playInfo';
  final response = await dio.get(url);
  return jsonDecode(response.data);
}

Future<Map<String, dynamic>> getMvData(String mvHash) async {
  final dio = Dio();
  final url =
      'http://m.kugou.com/app/i/mv.php?cmd=100&hash=$mvHash&ismp3=1&ext=mp4';
  final response = await dio.get(url);
  return jsonDecode(response.data);
}

String _formatDuration(int duration) {
  final minutes = (duration / 60).floor();
  final seconds = duration % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String _formatFileSize(int fileSize) {
  return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
}
