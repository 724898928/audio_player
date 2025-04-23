import 'package:audio_player/src/lee/common/PlayStatus.dart';
import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/common/RouterManager.dart';
import 'package:audio_player/src/lee/component/DDownButton.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/lee/model/MiGu.dart';
import 'package:audio_player/src/lee/view/Player.dart';
import 'package:audio_player/src/rust/api/simple.dart';
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
  BasePlatform platformTools = MiGu.getInstance();
  Songlist songlist = Songlist.getInstance();
  Widget container = Container();
  Widget? proSongs;
  bool selectAll = false;
  late MiGu miGu;
  late List<BasePlatform> platformList = [
    MiGu.getInstance(),
  ];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> labels = [
    {'label': "Source1", 'value': 1},
    {'label': "Source2", 'value': 2},
    // {'label': "Source1", 'value': 1},
  ];
  List<SearchSong> _searchResults = [];
  List<String> _searchHistory = ["流行音乐", "古典钢琴", "周杰伦"];
  List<String> _hotSearches = ["排行榜", "新歌速递", "经典老歌", "电子音乐"];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    // 模拟搜索请求
    var words = _searchController.text;
    miGu = await platformTools.doGetSongs(_searchController.text, 1, 10);
    setState(() {
      _searchResults = miGu.proSongList;
      if (!_searchHistory.contains(_searchController.text)) {
        _searchHistory.insert(0, _searchController.text);
      }
    });
  }

  void _handleSearchInput(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
      if (value.isEmpty) {
        _searchResults.clear();
      }
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "搜索歌曲、歌手、专辑...",
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _performSearch,
        ),
      ),
      onChanged: (value) => _handleSearchInput(value),
      onSubmitted: (value) => _performSearch(),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _isSearching = false;
    });
  }

  Widget _buildResultItem(SearchSong song) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          song.imgItems?.first["img"]!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song.name!),
      subtitle: Text("${song.proSong?.artist} · ${song.proSong?.album ?? ""}"),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            CheckBoxWidget(
              isCheck: song.selected ?? false,
              callback: (v) {
                song.selected = !song.selected!;
                print("song.proSong  song.proSong:${song.proSong}");
                if (song.selected!) {
                  song.getPlaySong();
                } else {
                  Songlist.getInstance().remove(song.proSong!);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              onPressed: () => _playSong(song),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildTagList(List<String> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTagItem(tag)).toList(),
    );
  }

  Widget _buildTagItem(String text) {
    return GestureDetector(
      onTap: () => _onTagSelected(text),
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.blue[50],
        shape: StadiumBorder(
          side: BorderSide(color: Colors.blue.shade100),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        if (index < _searchResults.length) {
          final item = _searchResults[index];
          return _buildResultItem(item);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHistoryItem(String text) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(text),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: () => _removeHistoryItem(text),
      ),
      onTap: () => _onHistorySelected(text),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children:
          _searchHistory.map((history) => _buildHistoryItem(history)).toList(),
    );
  }

  void _onTagSelected(String tag) {
    _searchController.text = tag;
    _performSearch();
  }

  void _onHistorySelected(String text) {
    _searchController.text = text;
    _performSearch();
  }

  void _removeHistoryItem(String text) {
    setState(() => _searchHistory.remove(text));
  }

  Future<void> _playSong(SearchSong song) async {
    song.selected = !song.selected!;
    if (song.selected!) {
      int idx = songlist.proPlaySongList.indexOf(song.proSong!);
      if (idx < 0) {
        idx = song.getPlaySong();
      }
      // PlayStatus.getInstance().newPlayIdx = idx;
      await PlayUtils.toPlay(idx: idx);
    }
  }

  Widget _buildBodyContent() {
    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle("热门搜索"),
        _buildTagList(_hotSearches),
        const SizedBox(height: 24),
        _buildSectionTitle("搜索历史"),
        _buildHistoryList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSearch,
          )
        ],
      ),
      body: _buildBodyContent(),
    );
  }

  /** 
  @override
  Widget build(BuildContext context) {
    print("build");
    return 
     Row(
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
  */
}
