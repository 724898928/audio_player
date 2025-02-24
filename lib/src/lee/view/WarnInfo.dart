import 'package:flutter/material.dart';

import '../component/featureContext.dart';

class WarnInfo extends StatefulWidget {
  const WarnInfo({super.key});

  @override
  State<WarnInfo> createState() => _WarnInfoState();
}

class _WarnInfoState extends State<WarnInfo> {
  final TextStyle style =
      TextStyle(fontSize: 16, color: Colors.black, wordSpacing: 0);
  @override
  Widget build(BuildContext context) {
    return FeatureContext(
      child: Card(
        child: Text(
            "说明:\n"
            "    本播放器是使用Flutter开发的UI界面,使用Rust开发的播放逻辑服务。\n"
            "    本播放器是本着学习和自用的目的开发的，请勿用于商业目的，若要用于商业目的, 请联系本人。\n"
            "    联系方式: 724898928@qq.com \n"
            "    如果您有更好的建议或者意见，请将建议或意见发我邮箱或联系本人。\n"
            "    如果您在使用中出现任何问题请将问题截图或文字方式发给我. \n"
            "    如果您要更好的体验音乐，请购买正版音乐。\n"
            "    本播放器的音乐来源于网络，如有侵权，请联系本人。\n",
            style: style),
      ),
    );
  }
}
