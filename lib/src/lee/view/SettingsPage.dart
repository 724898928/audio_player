import 'dart:convert';
import 'package:audio_player/src/lee/common/PlayStatus.dart';
import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/view/SongsListView.dart';
import 'package:audio_player/src/lee/view/WarnInfo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'RightInfo.dart';
import '../../rust/api/simple.dart';
import '../component/ElevatedButton2.dart';
import 'PayView.dart';
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
  Widget? currentWidget;
  int _currentIndex = 0;
  bool isWeixin = true;
  final List<String> images = [
    'assets/ad/ad1.PNG', // 替换为实际的图片路径
    'assets/ad/ad1.PNG',
    'assets/ad/ad1.PNG',
  ];
  late List<Map<String, dynamic>> features;
  late VoidCallback? callback;
  //SongsListView sv = SongsListView();
  @override
  initState() {
    features = [
      {"icon": Icons.money, "label": "打赏", "view": PayView()},
      {
        "icon": Icons.star,
        "label": "收藏",
        "view": SongsListView(),
      },
      {"icon": Icons.music_note, "label": "添加本地", "view": SongsListView()},
      {"icon": Icons.info, "label": "说明", "view": WarnInfo()},
      {"icon": Icons.copyright, "label": "版权", "view": RightInfo()},
    ];
    currentWidget = features.first['view'];
    event = (index) async {
      print("index: $index");
      currentWidget = features[index]['view'];
      switch (index) {
        case 0:
          await shareYourMoney();
          break;
        case 1:
          if (currentWidget is SongsListView) {
            (currentWidget as SongsListView).updateView();
          }
          break;
        case 2:
          await _scanLocalSongs();
          break;
        case 3:
          break;
      }
      setState(() {});
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Songlist sl = ChangeNotifierProvider.of<Songlist>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 图片轮播
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
              padding: const EdgeInsets.only(
                  right: 16.0, left: 16.0, top: 5, bottom: 5),
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
            flex: 6,
            child: currentWidget ?? Container(),
          ),
        ],
      ),
    );
  }

  Future<void> _scanLocalSongs() async {
    // List<ProSong> localSongs = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a', 'acc', 'midi'],
    );
    if (result != null) {
      print("_scanLocalSongs result != null result :$result");
      // songs.proPlaySongList.clear();
      List<String> songList = result.files.map((path) {
        var fileMetadata = PlayUtils.songMetadata(filePath: path.path!)?.trim();
        if (null != fileMetadata || fileMetadata!.isNotEmpty) {
          print("fileMetadata :$fileMetadata");
          var metaJson = jsonDecode(fileMetadata);
          // localSongs.add(
          //     ProSong.fromJson(metaJson as Map<String, dynamic>, path.path));
          songs.add(
              ProSong.fromJson(metaJson as Map<String, dynamic>, path.path));
          print("metaJson :$metaJson");
        }
        return path.path!;
      }).toList();
      print("songs :$songList");
      // currentWidget = await getlocalSongs(localSongs);
    } else {
      print("_scanLocalSongs result == null !");
    }
    // if (currentWidget is SongsListView) {
    //   (currentWidget as SongsListView).updateView();
    // }
    currentWidget = await getlocalSongs(songs.proPlaySongList);
    // setState(() {});
  }

  Future<Widget> getlocalSongs(List<ProSong> pSongs) async {
    return ListView.builder(
        itemCount: pSongs.length,
        itemBuilder: (ctx, idx) {
          return TextButton(
              onPressed: () async {
                // int id = songs.add(pSongs[idx]);
                // PlayStatus.getInstance().newPlayIdx = idx;
                await PlayUtils.toPlay(idx: idx);
              },
              child: Text('${pSongs[idx].title} - ${pSongs[idx].artist}'));
        });
  }

  List<Widget> iconsBut(AsyncValueChanged event) {
    return features.asMap().entries.map(
      (feature) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton2(
              icon: Icon(feature.value['icon']),
              label: Text(feature.value['label']),
            ),
          ),
          onTap: () async {
            await event.call(feature.key);
          },
        );
      },
    ).toList();
  }

  Future<void> shareYourMoney() async {}
}
