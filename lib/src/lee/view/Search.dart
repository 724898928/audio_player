import 'package:audio_player/src/lee/component/DDownButton.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/lee/model/platformTools.dart';
import 'package:flutter/material.dart';

import '../component/CheckBoxList.dart';
import '../model/Song.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchController = TextEditingController();
  var platformTools = MiGu();
  Widget container = Container();
  Widget? proSongs;
  bool selectAll = false;
  late List<SearchSong> proSongList;

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
                                  var words = searchController.text;
                                  var pt = await platformTools.doGetSongs(
                                      searchController.text, 1, 10);
                                  proSongs = pt.getWidget(context, (idx, v) {});
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.search,
                                  weight: 2,
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
                              flex: 1,
                              child: DDbutton(labels: [], onChange: (i) {}))
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
                                    (proSongs as CheckBoxList)
                                        .selectedAll(selectAll);
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
