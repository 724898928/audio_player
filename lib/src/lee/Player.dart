import 'package:flutter/cupertino.dart';

class Player extends StatefulWidget{
  Player({super.key});
  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("player");
  }
}