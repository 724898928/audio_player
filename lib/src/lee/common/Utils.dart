import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_player/src/lee/model/Song.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
//import 'package:flutter_media_metadata/flutter_media_metadata.dart';


class Utils {
  static final dio = Dio(BaseOptions(
    contentType: "application/x-www-form-urlencoded; charset=utf-8",
  ))..httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: (){
      final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
      client.badCertificateCallback = (cert,host,port )=>true;
      return client;
    },
    validateCertificate: (cert,host,port){
      return true;
    }
  );

  static final option = Options(
    headers: {
      "contentType": "application/x-www-form-urlencoded; charset=utf-8", // set content-type
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



  static Future<dynamic> download(String? url, String path) async {
    print("download url: $url, path :$path");
  }

  static Future<void> toShowDialog(BuildContext context,
      {required children}) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            backgroundColor: Colors.blueAccent,
            children: children,
          );
        });
  }

  static Future<void> showListDialog(
      BuildContext context, List<ProSong> songs, ValueChanged callback) async {
    toShowDialog(context, children: [
      Container(
          height: 500,
          width: 300,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, idx) {
                //return Text(songs[idx].toString());
                return Container(
                  padding: EdgeInsets.only(left: 30),
                  child: GestureDetector(
                      onTap: () async {
                        callback(BigInt.from(idx));
                      },
                      child: Text(
                          '${songs[idx].title.toString()}  ${songs[idx].artist.toString()}')),
                );
              },
              separatorBuilder: (ctx, i) {
                return Divider();
              },
              itemCount: songs.length))
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
