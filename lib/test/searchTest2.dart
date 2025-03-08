import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial'),
      home: MusicSearchPage(),
    );
  }
}

class MusicSearchPage extends StatefulWidget {
  const MusicSearchPage({super.key});

  @override
  State<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends State<MusicSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = ["流行音乐", "古典钢琴", "周杰伦"];
  List<String> _hotSearches = ["排行榜", "新歌速递", "经典老歌", "电子音乐"];
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    print("initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
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

  Widget _buildHistoryList() {
    return Column(
      children:
          _searchHistory.map((history) => _buildHistoryItem(history)).toList(),
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

  Widget _buildSearchResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _buildResultItem(item);
      },
    );
  }

  Widget _buildResultItem(Map<String, String> song) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          song["cover"]!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song["title"]!),
      subtitle: Text("${song["artist"]} · ${song["album"]}"),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () => _playSong(song),
      ),
    );
  }

  void _handleSearchInput(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
      if (value.isEmpty) {
        _searchResults.clear();
      }
    });
  }

  void _performSearch() {
    // 模拟搜索请求
    setState(() {
      _searchResults = [
        {
          "title": "七里香",
          "artist": "周杰伦",
          "album": "七里香",
          "cover": "https://example.com/cover1.jpg",
          "url": ""
        },
        {
          "title": "青花瓷",
          "artist": "周杰伦",
          "album": "我很忙",
          "cover": "https://example.com/cover2.jpg",
          "url": ""
        }
      ];
      if (!_searchHistory.contains(_searchController.text)) {
        _searchHistory.insert(0, _searchController.text);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _isSearching = false;
    });
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

  void _playSong(Map<String, String> song) {
    // 播放音乐实现
  }
}
