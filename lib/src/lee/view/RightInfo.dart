import 'package:audio_player/src/lee/component/featureContext.dart';
import 'package:flutter/material.dart';

class RightInfo extends StatefulWidget {
  const RightInfo({super.key});

  @override
  State<RightInfo> createState() => _RightInfoState();
}

class _RightInfoState extends State<RightInfo> {
  @override
  Widget build(BuildContext context) {
    return FeatureContext(
      child: const Card(
        child: Column(
          children: [
            Text("《中华人民共和国著作权法(2010修正)》"),
            Text("为保护文学、艺术和科学作品作者的著作权，以及与著作权有关的权益，鼓励有益于社会主义精神文明、物质文明建设的作品的创作和传播，促进社会主义文化和科学事业的发展与繁荣，根据宪法制定本法。" +
                "《著作权法》，加强对音乐作品特别是数字音乐作品的版权保护，严厉打击未经许可传播音乐作品的侵权盗版行为，支持权利人和使用者开展版权合作，推动音乐作品相互授权和广泛传播，鼓励相关单位积极" +
                "探索网络环境下传播音乐作品的商业模式，推动建立良好的网络音乐版权秩序和运营生态，逐步实现数字音乐的正版化运营。完善反盗版举报和查处奖励机制，加大对网络非法传播、假冒出版单位制作出版等" +
                "各类侵权盗版行为的打击力度。强化市场监管，坚决依法查处含有有害内容的音乐作品。"),
            Text("请支持正版音乐，本软件仅供参考与学习")
          ],
        ),
      ),
    );
  }
}
