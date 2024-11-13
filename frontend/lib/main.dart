import 'package:flutter/material.dart';
import 'theme.dart';
import 'sentence_structure.dart';
import 'word_mc.dart';

void main() {
  runApp(const HakkaLearningApp());
}

class HakkaLearningApp extends StatelessWidget {
  const HakkaLearningApp({super.key});
  // Although not mandatory, it is recommended to provide a key.
  // This is useful in debugging and testing scenarios.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '客語學習模組',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SentenceStructureGame(),
    const WordMultipleChoiceGame(),
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
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
