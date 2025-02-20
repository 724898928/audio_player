import 'package:flutter/material.dart';

import 'featureContext.dart';

class PayView extends StatefulWidget {
  const PayView({super.key});

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  late VoidCallback? callback;
  bool isWeixin = true;

  @override
  Widget build(BuildContext context) {
    return FeatureContext(
      child: Card(
        child: GestureDetector(
          child: isWeixin
              ? Image.asset("assets/img/weixin.jpg")
              : Image.asset("assets/img/zhifubao.jpg"),
          onTap: () {
            print("GestureDetector isWeixin:$isWeixin");

            callback?.call();
            setState(() {
              isWeixin = !isWeixin;
            });
          },
        ),
      ),
      callback: (p) {
        callback = p;
      },
    );
  }
}
