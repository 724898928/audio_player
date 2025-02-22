import 'package:flutter/material.dart';

import '../component/featureContext.dart';

class WarnInfo extends StatefulWidget {
  const WarnInfo({super.key});

  @override
  State<WarnInfo> createState() => _WarnInfoState();
}

class _WarnInfoState extends State<WarnInfo> {
  @override
  Widget build(BuildContext context) {
    return FeatureContext(
      child: const Card(
        child: Text("说明:\n"
            "本播放器是本着学习和自用的目的开发的，请勿用于商业目的，若要用于商业目的请联系本人。\n"
            "本播放器是使用Flutter开发的UI界面，使用Rust开发的播放逻辑服务。"),
      ),
    );
  }
}
