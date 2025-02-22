import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('自定义滑块指示器')),
        body: Center(
          child: CustomSlider(),
        ),
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _currentValue = 50;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        valueIndicatorShape: DropArrowSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.blue,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
        ),
      ),
      child: Slider(
        value: _currentValue,
        min: 0,
        max: 100,
        divisions: 100,
        label: '${_currentValue.round()}',
        onChanged: (double value) {
          setState(() => _currentValue = value);
        },
      ),
    );
  }
}

// 自定义下拉箭头形状的指示器
class DropArrowSliderValueIndicatorShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(40, 40); // 指示器尺寸
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme.valueIndicatorColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    // 绘制下拉箭头形状
    final path = Path();
    path.moveTo(center.dx - 15, center.dy - 20);
    path.lineTo(center.dx + 15, center.dy - 20);
    path.lineTo(center.dx, center.dy);
    path.close();

    canvas.drawPath(path, paint);

    // 绘制文本
    labelPainter.paint(
      canvas,
      Offset(
        center.dx - labelPainter.width / 2,
        center.dy - 40, // 调整文本位置
      ),
    );
  }
}
