import 'package:flutter/material.dart';
import 'theme.dart';
import 'sentence_structure.dart';
import 'word_MC.dart';
import 'video_player.dart';

void main() {
  runApp(HakkaLearningApp());
}

class HakkaLearningApp extends StatelessWidget {
  const HakkaLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '客語學習模組',
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SentenceStructureGame(),
    WordMultipleChoiceGame(),
    VideoPlayerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('客語學習模組'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                '選擇遊戲',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('句子排列遊戲'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // 關閉 Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.spellcheck),
              title: const Text('單字選擇遊戲'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // 關閉 Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('影片學習'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
