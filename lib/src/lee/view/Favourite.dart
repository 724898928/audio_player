import 'package:flutter/material.dart';

import '../component/featureContext.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return FeatureContext(
        child: const Card(
      child: Text("收藏"),
    ));
  }
}
