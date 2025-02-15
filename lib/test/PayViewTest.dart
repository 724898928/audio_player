import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 30),
                _buildBeggingText(),
                SizedBox(height: 40),
                _buildDonateButton(),
                _buildArrowHint(),
                SizedBox(height: 40),
                _buildQRCodeSection(),
                SizedBox(height: 30),
                _buildAlipaySearch(),
                SizedBox(height: 50),
                _buildFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 顶部兔子图标
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.pets, size: 60, color: Colors.grey),
        Text("一只要饭的小白兔...", style: TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }

  // 乞讨文字
  Widget _buildBeggingText() {
    return Text(
      "大哥哥大姐们啊！你们都是有钱的人呐～\n谁有那多余的零钱？给我这流浪的人啊...",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, height: 1.5),
    );
  }

  // 打赏按钮
  Widget _buildDonateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
      onPressed: () {},
      child: Text("打赏", style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  // 箭头提示
  Widget _buildArrowHint() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text("↑↑↑↑疯狂暗示↑↑↑↑~",
              style: TextStyle(color: Colors.orange, fontSize: 16)),
          SizedBox(height: 20),
          Text("扫码领红包",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("用支付宝天天可领取扫取赔支", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 扫码区域
  Widget _buildQRCodeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
          SizedBox(height: 10),
          Text("打开支付宝[扫一扫]",
              style: TextStyle(fontSize: 16, color: Colors.blue)),
        ],
      ),
    );
  }

  // 支付宝搜索
  Widget _buildAlipaySearch() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.align_vertical_bottom, color: Colors.blue),
          SizedBox(width: 10),
          Text.rich(TextSpan(children: [
            TextSpan(text: "打开支付宝首页搜索 "),
            TextSpan(
                text: "\"6893527\"",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            TextSpan(text: "，即可领红包"),
          ])),
        ],
      ),
    );
  }

  // 底部信息
  Widget _buildFooter() {
    return Column(
      children: [
        Text("© Powered by LAOYEE", style: TextStyle(color: Colors.grey)),
        SizedBox(height: 10),
        Text("温馨提示：网页功能仅供娱乐，打赏金额将全部用于网站建设",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
