import 'package:flutter/material.dart';
import 'theme.dart';
import 'sentence_structure.dart';
import 'word_MC.dart';

void main() {
  runApp(HakkaLearningApp());
}

class HakkaLearningApp extends StatelessWidget {
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
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SentenceStructureGame(),
    WordMultipleChoiceGame(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('客語學習模組'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
              leading: Icon(Icons.text_fields),
              title: Text('句子排列遊戲'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // 關閉 Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.spellcheck),
              title: Text('單字選擇遊戲'),
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
