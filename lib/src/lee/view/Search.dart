import 'package:audio_player/src/lee/component/DDownButton.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/lee/model/platformTools.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchController = TextEditingController();
  var PlatformTools = MiGu();
  Widget containner = Container();
  Widget? proSongs;

  @override
  Widget build(BuildContext context) {
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
                                  // TODO search
                                  var words = searchController.text;
                                  var pt = await PlatformTools.doGetSongs(
                                      searchController.text, 1, 10);
                                  proSongs =
                                      pt.getWidget(context, null) ?? containner;
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
                      flex: 9,
                      child: proSongs ?? containner,
                    )
                  ],
                ))),
        // right side
        Expanded(
            child: Card(
          child: containner,
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
