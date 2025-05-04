import 'dart:async';
import 'dart:io';
import 'package:audio_player/src/lee/common/DatabaseHelper.dart';
import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/model/Song.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Utils {
  static final dio = Dio(BaseOptions(
    contentType: "application/x-www-form-urlencoded; charset=utf-8",
  ))
    ..httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final HttpClient client =
          HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    }, validateCertificate: (cert, host, port) {
      return true;
    });

  static final option = Options(
    headers: {
      "contentType":
          "application/x-www-form-urlencoded; charset=utf-8", // set content-type
    },
  );

  static Future<dynamic> get(String url, {Map<String, dynamic>? qp}) async {
    try {
      var response = await dio.get(url);
      //  print("response: " + response.toString());
      return '$response';
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> download(String? url, String? path, String fileName,
      {ValueChanged? callBack}) async {
    final savePath = '${path}/$fileName.mp3';
    print("download url: $url, savePath :$savePath");
    if (null != url && null != savePath) {
      try {
        var response = await dio.download(
          url!,
          savePath,
          onReceiveProgress: (received, total) {
            if (total <= 0) return;
            var pross = (received / total * 100).toStringAsFixed(0);
            print("Downloading: $pross% , total:${total}, received:$received");
            if ('$pross' == '100') {
              callBack?.call(true);
            }
          },
        );
        //  print("response: " + response.toString());
        return '$response';
      } catch (e) {
        print(e);
      }
    }
    return callBack?.call(false);
  }

  static Future<T?> fastDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        // 背景遮罩颜色
        pageBuilder: (BuildContext context, _, __) {
          return builder(context);
        },
        transitionDuration: Duration(milliseconds: 0),
        // 打开动画时间 0
        reverseTransitionDuration: Duration(milliseconds: 0), // 关闭动画时间 0
      ),
    );
  }

  static Future<void> cancelDialog(BuildContext context,
      {required children}) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: children,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  static Future<void> toShowDialog(BuildContext context,
      {required children}) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return SimpleDialog(
          backgroundColor: Colors.blueAccent,
          children: children,
        );
      },
    );
  }

  static Future<void> showListDialog(BuildContext context, List<ProSong> songs,
      AsyncValueChanged callback) async {
    toShowDialog(context, children: [
      StatefulBuilder(builder: (context, setState) {
        return Container(
            height: 500,
            width: 300,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (ctx, idx) {
                  return Container(
                    height: 30,
                    padding:  EdgeInsets.only(left: 10.0,top: 0.0,right: 0.0,bottom: 0.0),
                    child: Row(
                    children: [
                      Expanded(flex: 4, child: GestureDetector(
                    onTap: () async {
                    await callback(idx);
                    },
                    child: Text(
                        '${songs[idx].title.toString()}  ${songs[idx].artist.toString()}',overflow: TextOverflow.ellipsis),)),
                     Expanded(flex: 1, child:  IconButton(
                         onPressed: () async{
                           songs[idx].isFavorite = !songs[idx].isFavorite!;
                           await DatabaseHelper.instance.upsertSong(songs[idx]);
                           setState(() {});
                         },
                         icon: Icon(songs[idx].isFavorite == true
                             ? Icons.favorite
                             : Icons.favorite_border)))

                    ],
                  ),) ;
                },
                separatorBuilder: (ctx, i) {
                  return Divider();
                },
                itemCount: songs.length));
      })
    ]);
  }
//
// Future<List<dynamic>> getSongsMetaData(List<String> songs) async {
//   var metas = songs.map((e) async {
//     final metadata = await MetadataRetriever.fromFile(File(e));
//     return metadata;
//   }).toList();
//   return metas;
// }
}

extension DurationX on Duration {
  String toFormattedString() {
    return //'${inHours.toString().padLeft(2, '0')}:'
        '${(inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
