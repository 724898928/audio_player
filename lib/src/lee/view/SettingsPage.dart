import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../rust/api/simple.dart';
import '../component/ChangeNotifierProvider.dart';
import '../model/Song.dart';
import '../model/SongList.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

typedef AsyncValueChanged = Future<void> Function(dynamic);

class _SettingsWidgetState extends State<SettingsWidget> {
  Songlist songs = Songlist.getInstance();
  late AsyncValueChanged event;
  int _currentIndex = 0;
  final List<String> images = [
    'assets/image1.png', // 替换为实际的图片路径
    'assets/image2.png',
    'assets/image3.png',
  ];

  final List<Map<String, dynamic>> features = [
    {"icon": Icons.music_note, "label": "扫描本地音乐"},
    {"icon": Icons.star, "label": "收藏"},
    {"icon": Icons.info, "label": "说明"},
    {"icon": Icons.copyright, "label": "版权"},
  ];

  Future<void> scanLocalSongs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a', 'acc', 'midi'],
    );
    if (result != null) {
      // songs.proPlaySongList.clear();
      List<String> songList = result.files.map((path) {
        var fileMetadata = getSongMetadata(filePath: path.path!)?.trim();
        if (null != fileMetadata || fileMetadata!.isNotEmpty) {
          print("fileMetadata :$fileMetadata");
          var metaJson = jsonDecode(fileMetadata);
          songs.add(
              ProSong.fromJson(metaJson as Map<String, dynamic>, path.path));
          print("metaJson :$metaJson");
        }
        return path.path!;
      }).toList();
      print("songs :$songList");

      print("songs :$songs");
    }
  }

  List<Widget> iconsBut(AsyncValueChanged event) {
    return features.asMap().entries.map(
      (feature) {
        return GestureDetector(
          child: Column(
            children: [
              IconButton(
                icon: Icon(feature.value['icon']),
                color: Colors.blue,
                onPressed: () {
                  // event(feature.key);
                },
              ),
              Text(feature.value['label']),
            ],
          ),
          onTap: () async {
            await event.call(feature.key);
          },
        );
      },
    ).toList();
  }

  @override
  initState() {
    super.initState();
    event = (indx) async {
      print("index: $indx");
      switch (indx) {
        case 0:
          await scanLocalSongs();
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    Songlist sl = ChangeNotifierProvider.of<Songlist>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 图片轮播
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                          items: images.map((imagePath) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: images.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => {},
                                child: Container(
                                  width: 10.0,
                                  height: 10.0,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == entry.key
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

            // 按钮功能区
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: iconsBut(event),
                  ),
                ),
              ),
            ),

            // 说明区域
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Card(
                      child: Text(
                    "说明:\n"
                    "本播放器是本着学习和自用的目的开发的，请勿用于商业目的，若要用于商业目的请联系本人。\n"
                    "本播放器是使用Flutter开发的UI界面，使用Rust开发的播放逻辑服务。",
                    style: TextStyle(fontSize: 14),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   //Songlist sl = ChangeNotifierProvider.of<Songlist>(context);
  //   return ElevatedButton(
  //       onPressed: () async {
  //         FilePickerResult? result = await FilePicker.platform.pickFiles(
  //           allowMultiple: true,
  //           type: FileType.audio,
  //           allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a', 'acc', 'midi'],
  //         );
  //         if (result != null) {
  //           // songs.proPlaySongList.clear();
  //           List<String> songList = result.files.map((path) {
  //             var fileMetadata = getSongMetadata(filePath: path.path!)?.trim();
  //             if (null != fileMetadata || fileMetadata!.isNotEmpty) {
  //               print("fileMetadata :$fileMetadata");
  //               var metaJson = jsonDecode(fileMetadata);
  //               songs.add(ProSong.fromJson(
  //                   metaJson as Map<String, dynamic>, path.path));
  //               print("metaJson :$metaJson");
  //             }
  //             return path.path!;
  //           }).toList();
  //           print("songs :$songList");

  //           print("songs :$songs");
  //         }
  //       },
  //       child: Text('Local songs file path'));
  // }
}
