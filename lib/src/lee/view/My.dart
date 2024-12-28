import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../rust/api/simple.dart';
import '../component/ChangeNotifierProvider.dart';
import '../model/Song.dart';
import '../model/SongList.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  Songlist songs = Songlist.getInstance();

  @override
  Widget build(BuildContext context) {
    //Songlist sl = ChangeNotifierProvider.of<Songlist>(context);
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.audio,
            allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a', 'acc', 'midi'],
          );
          if (result != null) {
            songs.proPlaySongList.clear();
            List<String> songList = result.files.map((path) {
              var fileMetadata = getSongMetadata(filePath: path.path!)?.trim();
              if (null != fileMetadata || fileMetadata!.isNotEmpty) {
                print("fileMetadata :$fileMetadata");
                var metaJson = jsonDecode(fileMetadata);
                songs.add(ProSong.fromJson(metaJson as Map<String, dynamic>));
                print("metaJson :$metaJson");
              }
              return path.path!;
            }).toList();
            print("songs :$songList");

            print("songs :$songs");
          }
        },
        child: Text('Local songs file path'));
  }
}
