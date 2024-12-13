import 'package:audio_player/src/lee/component/CustomBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:audio_player/src/rust/frb_generated.dart';
import 'src/lee/EventBus.dart';
import 'src/lee/RouterManager.dart';
  // 定义一个top-level (全局)变量, 页面引入该文件后可以直接使用Bus
EventBus eventBus = EventBus();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  RouterManager.initRouter();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.blueAccent),
    onGenerateRoute: RouterManager.router!.generator,
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _selectedIndex = 0;
  static late List<Widget> _widgetOptions;
  @override
  void initState() {
    _widgetOptions = RouterManager.homeMyListWidget;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_rust_bridge'),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "My"),
          ],
          onTap: _onItemTapped),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouterManager.router!.navigateTo(
            context, RouterManager.playerPath,
            // clearStack: true
          );
        },
        child: Icon(Icons.music_note),
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
