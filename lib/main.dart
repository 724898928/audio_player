import 'package:flutter/material.dart';
import 'package:audio_player/src/rust/api/simple.dart';
import 'package:audio_player/src/rust/frb_generated.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  late Map<String, WidgetBuilder> routes;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    //  onGenerateRoute: ,
      theme: ThemeData(colorScheme:  ColorScheme.fromSeed(seedColor: Colors.blueAccent), useMaterial3: true),
      routes: {
        //  "home" => Home(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_rust_bridge quickstart'),
        ),
        body: Text("flutter_rust_bridge simple${greet(name: 'lixin')}"),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey,
          height: 40,
          shape: CircularNotchedRectangle(),
          notchMargin: 3,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            IconButton(icon: Icon(Icons.home),tooltip: "Home",onPressed: (){}, padding: EdgeInsets.all(0),),
           // IconButton(icon: Icon(Icons.music_note), tooltip: "Music",onPressed: (){},padding: EdgeInsets.all(0)),
            IconButton(icon: Icon(Icons.account_circle),tooltip: "My",onPressed: (){},padding: EdgeInsets.all(0))
          ],) ,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},child: Icon(Icons.music_note),
          tooltip: "Music",
          backgroundColor: Colors.blueAccent,
          shape: const CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),

    );
  }
}
