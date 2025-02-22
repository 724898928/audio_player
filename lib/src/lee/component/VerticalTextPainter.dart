import 'package:flutter/material.dart';

class VerticalText extends StatelessWidget {
  VerticalText({super.key, required this.text})
      : textStyle =
            TextStyle(fontSize: 16, color: Colors.black, wordSpacing: 0);
  final String text;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(50, 200),
      painter: VerticalTextPainter(text: text, textStyle: textStyle),
    );
  }
}

class VerticalTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  VerticalTextPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    double offsetY = 0;
    for (var char in text.split('')) {
      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, offsetY));
      offsetY += textPainter.height;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
