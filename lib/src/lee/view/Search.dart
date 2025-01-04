import 'package:audio_player/src/lee/component/DDownButton.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/lee/model/MiGu.dart';
import 'package:flutter/material.dart';

import '../common/Utils.dart';
import '../component/CheckBoxList.dart';
import '../model/BasePlatform.dart';
import '../model/Song.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchController = TextEditingController();
  BasePlatform platformTools = MiGu.getInstance();
  Widget container = Container();
  Widget? proSongs;
  bool selectAll = false;
  late List<SearchSong> proSongList;
  late List<BasePlatform> platformList = [
    MiGu.getInstance(),
  ];

  List<Map<String, dynamic>> labels = [
    {'label': "Source1", 'value': 1},
    {'label': "Source2", 'value': 2},
    // {'label': "Source1", 'value': 1},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Row(
      children: [
        // lift the search bar
        Expanded(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.all(0))),
                                padding: EdgeInsets.all(0),
                                iconSize: 50,
                                alignment: Alignment.center,
                                onPressed: () async {
                                  selectAll = false;
                                  var words = searchController.text;
                                  var miGu = await platformTools.doGetSongs(
                                      searchController.text, 1, 10);
                                  //proSongList = miGu.proSongList;
                                  setState(() {
                                    proSongs = CheckBoxList(
                                        searchSelected: miGu.proSongList,
                                        callback: (idx, v) {
                                          if (v) {
                                            miGu.proSongList[idx].getPlaySong();
                                          } else {
                                            miGu.proSongList[idx].removeSong();
                                          }
                                        });
                                    // proSongs =
                                    //     miGu.getWidget(context, (i, v) {});
                                  });
                                },
                                icon: Icon(
                                  Icons.search,
                                  weight: 1,
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: Form(
                                child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Enter song name or singer name',
                                hintText: 'Search',
                              ),
                              controller: searchController,
                            )),
                          ),
                          Expanded(
                              flex: 2,
                              child: DDbutton(
                                  labels: labels,
                                  menuWidth: 100,
                                  onChange: (i) {
                                    platformTools = platformList[i];
                                    setState(() {});
                                  }))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                              leading: Checkbox(
                                value: selectAll,
                                onChanged: (v) {
                                  if (null != proSongs) {
                                    selectAll = !selectAll;
                                    CheckBoxList.selectedAll(selectAll);
                                  }
                                  setState(() {});
                                  print("Select All");
                                },
                                semanticLabel: "Select All",
                              ),
                              title: Text("Select All")),
                        ),
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () {
                                  var sl = Songlist.getInstance();
                                  var path = "";
                                  sl.proPlaySongList.map((e) {
                                    return Utils.download(e.url, path);
                                  });
                                  print("download");
                                },
                                child: Text("download"))),
                      ]),
                    ),
                    Expanded(
                      flex: 9,
                      child: proSongs ?? container,
                    )
                  ],
                ))),
        //right side
        Expanded(
            child: Card(
          child: Text("right side"),
        ))
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
