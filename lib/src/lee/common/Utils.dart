import 'dart:async';

import 'package:flutter/material.dart';

class Utils {
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
      BuildContext context, List<dynamic> songs, ValueChanged callback) async {
    toShowDialog(context, children: [
      Container(
          height: 500,
          width: 300,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, idx) {
                //return Text(songs[idx].toString());
                return ElevatedButton(
                    onPressed: () async {
                      callback(BigInt.from(idx));
                    },
                    child: Text(songs[idx].toString()));
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
