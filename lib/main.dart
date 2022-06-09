import 'package:flutter/material.dart';
import 'package:video_player_example/chewie_player.dart';
import 'package:video_player_example/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Video Player'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoApp(),
              ),
            ),
          ),
          ListTile(
            title: Text('Chewie Video Player'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoAppAlternative(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
