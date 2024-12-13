import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
