import 'package:flutter/material.dart';

import 'ChangeNotifierProvider.dart';

class Consumer<T> extends StatelessWidget {
  Consumer({
    Key? key,
    required this.builder,
  });

  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return builder(context, ChangeNotifierProvider.of<T>(context));
  }
}
