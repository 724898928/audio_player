import 'package:flutter/material.dart';

class ElevatedButton2 extends StatelessWidget {
  Widget icon;
  final VoidCallback? onPressed;
  double height;
  Widget label;
  ElevatedButton2(
      {super.key,
      required this.icon,
      required this.label,
      this.onPressed,
      this.height = 0});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        // 保持默认阴影和颜色
        elevation: 8,
        shadowColor: Colors.transparent,
        // 最小尺寸控制
        //  maximumSize: Size(120, 100),
        // 交互状态颜色
        foregroundColor: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max, // 紧凑布局
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: height), // 图标和文字间距
          label,
        ],
      ),
    );
  }
}
