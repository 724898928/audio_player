import 'package:audio_player/src/lee/common/PlayUtils.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:audio_player/src/lee/model/MiGu.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../common/Utils.dart';
import '../component/CheckBoxList.dart';
import '../model/BasePlatform.dart';
import '../model/Song.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

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

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position,backgroundColor: Colors.blueAccent);
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
        padding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
        height: 30,
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  onPressed: () async {
                    // TODO 下载当前歌曲
                    final path = await FilePicker.platform.getDirectoryPath();
                    var res = song.getPlaySong();
                    if (null != path && path.isNotEmpty) {
                      await Utils.download(song.proSong?.url, path, song.name!,
                          callBack: (v) {
                        if (v) {
                          _showToast("Download successfully!",
                              position: FlutterToastr.center);
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.download)), 

            ),
            CheckBoxWidget(
              isCheck: song.selected ?? false,
              callback: (v) {
                song.selected = !song.selected!;
                print("song.proSong  song.proSong:${song.proSong}");
                if (song.selected!) {
                  song.getPlaySong();
                  Songlist.getInstance().add(song.proSong!);
                } else {
                  Songlist.getInstance().remove(song.proSong!);
                }
              },
            ),
            SizedBox(
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: const Icon(Icons.play_circle_outline),
                  onPressed: () => _playSong(song),
                ))
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
}
