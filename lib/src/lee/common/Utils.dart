import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_player/src/lee/model/Song.dart';
import 'package:audio_player/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Utils {
  static final dio = Dio(BaseOptions(
    contentType: Headers.formUrlEncodedContentType,
  ));

  static final option = Options(
    headers: {
      "contentType": "application/x-www-form-urlencoded", // set content-type
    },
  );

  static Future<dynamic> get(String url, Map<String, dynamic>? qp) async {
    // Uri uri = Uri(scheme: 'https', host: url, queryParameters: qp);
    try {
      print("https get uri: " + url.toString());
      var response = await dio.get(url);
      print("response: " + response.toString());
      if (response.statusCode == 200) {
        return response.data;
        // return jsonDecode(response.data);
      } else {
        print("Error: " + response.data);
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> hget(String url) async {
    var requs ;
    if(Platform.isAndroid){

    }else{
      requs = await httpGet(url: url);
    }
    //print("value :$requs");
    return jsonDecode(requs);
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
}

extension DurationX on Duration {
  String toFormattedString() {
    return //'${inHours.toString().padLeft(2, '0')}:'
        '${(inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
