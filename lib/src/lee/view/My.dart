import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/ChangeNotifierProvider.dart';
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
            List<String> songList = result.files.map((path) {
              return path.path!;
            }).toList();
            print("songs :$songList");
            songs.addSongs(songList);
            print("songs :$songs");
          }
        },
        child: Text('Local songs file path'));
  }
}
