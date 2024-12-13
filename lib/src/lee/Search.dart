import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              var sl = Songlist.getInstance().add({"lixin": "18"});
            },
            child: const Text("search"))
      ],
    );
  }
}
