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
  @override
  _MusicSearchPageState createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends State<MusicSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = ["周杰伦", "林俊杰", "Eminem", "Beyond"];
  List<Map<String, String>> _searchResults = [];

  // 模拟搜索
  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 6) {
          _searchHistory.removeLast();
        }
      }

      _searchResults = [
        {"title": "$query - 歌曲 1", "artist": "歌手 A"},
        {"title": "$query - 歌曲 2", "artist": "歌手 B"},
        {"title": "$query - 歌曲 3", "artist": "歌手 C"},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("搜索音乐"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 搜索栏
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "搜索歌曲或歌手...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: _performSearch,
            ),
            SizedBox(height: 16),

            // 搜索历史
            if (_searchHistory.isNotEmpty) _buildSearchHistory(),

            // 搜索结果
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  // 构建搜索历史
  Widget _buildSearchHistory() {
    return Wrap(
      spacing: 8,
      children: _searchHistory.map((query) {
        return GestureDetector(
          onTap: () => _performSearch(query),
          child: Chip(
            label: Text(query),
            deleteIcon: Icon(Icons.close, size: 18),
            onDeleted: () {
              setState(() {
                _searchHistory.remove(query);
              });
            },
          ),
        );
      }).toList(),
    );
  }

  // 构建搜索结果列表
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(child: Text("暂无搜索结果", style: TextStyle(fontSize: 16)));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final song = _searchResults[index];
        return ListTile(
          leading: Icon(Icons.music_note, color: Colors.blue),
          title: Text(song["title"]!),
          subtitle: Text(song["artist"]!),
          trailing: IconButton(
            icon: Icon(Icons.play_arrow, color: Colors.blue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("播放 ${song["title"]}")),
              );
            },
          ),
        );
      },
    );
  }
}
