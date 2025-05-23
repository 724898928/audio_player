import 'dart:io';


import 'package:audio_player/src/lee/common/PlayStatus.dart';
import 'package:audio_player/src/lee/component/ChangeNotifierProvider.dart';
import 'package:audio_player/src/lee/component/CustomBottomNavigationBar.dart';
import 'package:audio_player/src/lee/model/SongList.dart';
import 'package:flutter/material.dart';
import 'package:audio_player/src/rust/frb_generated.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'src/lee/common/EventBus.dart';
import 'src/lee/common/RouterManager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// 定义一个top-level (全局)变量, 页面引入该文件后可以直接使用Bus
EventBus eventBus = EventBus();
PlayStatus status = PlayStatus();
Future<void> main() async {

  RouterManager.initRouter();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await RustLib.init();
    await windowManager.ensureInitialized();
    sqfliteFfiInit();
    WindowOptions windowOptions = WindowOptions(
        center: true,
        minimumSize: Size(470, 825),
        maximumSize: Size(470, 830),
        backgroundColor: Colors.transparent); // 设置最小宽度和高度
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
    return ChangeNotifierProvider(
        data: Songlist.getInstance(),
        child: Builder(builder: (context) {
          return Scaffold(
            // appBar: AppBar(
            //     //    title: const Text('flutter_rust_bridge'),
            //     ),
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: "search"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ],
                onTap: _onItemTapped),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                var sl = ChangeNotifierProvider.of<Songlist>(context);
                RouterManager.router!.navigateTo(
                    context, RouterManager.playerPath,
                    routeSettings: RouteSettings(arguments: sl)
                    // clearStack: true
                    );
              },
              child: Icon(Icons.music_note),
              backgroundColor: Colors.blueAccent,
              shape: const CircleBorder(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          );
        }));
  }
}
