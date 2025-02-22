import 'dart:convert';

import 'package:audio_player/src/lee/component/VerticalTextPainter.dart';
import 'package:flutter/material.dart';

import '../common/comm.dart';
import '../component/featureContext.dart';

class PayView extends StatefulWidget {
  const PayView({super.key});

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  late VoidCallback? callback;
  bool isWeixin = true;
  int? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return FeatureContext(
      child: Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, top: 50),
              width: 50,
              alignment: Alignment.topCenter,
              child: VerticalText(text: "大哥哥大姐们啊, 你们都是有钱的人呐"),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      color: Colors.red,
                      //padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "打赏",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            // color: Colors.red,
                            backgroundColor: Colors.red),
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                    isWeixin
                        ? Image.memory(base64Decode(WeiXinImage))
                        : Image.memory(base64Decode(ZhiFuBaoImage)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          //flex: 1,
                          // padding: EdgeInsets.all(0),
                          // width: 120,
                          // height: 50,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('微信扫码'),
                            leading: Checkbox(
                              value: isWeixin,
                              onChanged: (v) {
                                setState(() {
                                  isWeixin = !isWeixin;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          //   flex: 1,
                          // padding: EdgeInsets.all(0),
                          // width: 250,
                          // height: 50,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('支付宝扫码'),
                            leading: Checkbox(
                              value: !isWeixin,
                              onChanged: (v) {
                                setState(() {
                                  isWeixin = !isWeixin;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                print("GestureDetector isWeixin:$isWeixin");

                callback?.call();
                setState(() {
                  isWeixin = !isWeixin;
                });
              },
            ),
            Container(
              width: 50,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 15, top: 50),
              child: VerticalText(text: "谁有那多余的零钱,给我这可怜的人啊"),
            ),
          ],
        ),
      ),
      callback: (p) {
        callback = p;
      },
    );
  }
}
