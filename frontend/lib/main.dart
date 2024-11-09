// main.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(HakkaLearningApp());
}

class HakkaLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '句子排列遊戲',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SentenceArrangementGame(),
    );
  }
}

class SentenceArrangementGame extends StatefulWidget {
  @override
  _SentenceArrangementGameState createState() => _SentenceArrangementGameState();
}

class _SentenceArrangementGameState extends State<SentenceArrangementGame> {
  List<String> hakkaWords = [];
  String chineseSentence = '';
  List<String> correctOrder = [];
  int health = 5;
  int experience = 0;

  @override
  void initState() {
    super.initState();
    fetchSentenceData(); // 初始化時從API獲取句子資料
  }

  // 整合 API：取得句子資料
  Future<void> fetchSentenceData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/sentences/'));
      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        var data = json.decode(utf8Response)[0]; // 使用 utf8 進行解碼
        setState(() {
          chineseSentence = data['chinese_sentence'];
          hakkaWords = List<String>.from(data['hakka_words']);
          correctOrder = List<String>.from(data['hakka_words']);
        });
      } else {
        throw Exception('Failed to load sentences');
      }
    } catch (e) {
      print("Error fetching sentences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('句子排列遊戲'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 生命值和經驗值
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('❤️ 生命值: $health', style: TextStyle(fontSize: 18)),
                Text('EXP: $experience', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 10),
            // 華語例句展示
            Text(
              '華語例句: $chineseSentence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // 客語字卡區域
            Text('拖曳字卡排列成正確的客語順序:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: hakkaWords
                    .map((word) => ListTile(
                          key: ValueKey(word),
                          title: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.lightBlueAccent,
                            child: Text(
                              word,
                              style: TextStyle(fontSize: 18, fontFamily: 'NotoSansCJK'), // 建議加上支援CJK的字體
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            // 確認答案按鈕
            Center(
              child: ElevatedButton(
                onPressed: _checkAnswer,
                child: Text('確認答案'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 拖曳事件處理
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = hakkaWords.removeAt(oldIndex);
      hakkaWords.insert(newIndex, item);
    });
  }

  // 確認答案
  void _checkAnswer() {
    if (hakkaWords.join() == correctOrder.join()) {
      setState(() {
        experience += 10;
      });
      if (experience >= 100) {
        _showMessage("恭喜過關！");
      } else {
        _showMessage("正確！");
      }
    } else {
      setState(() {
        health -= 1;
      });
      if (health <= 0) {
        _showMessage("生命值耗盡，遊戲結束！");
      } else {
        _showMessage("錯誤，請再試一次！");
      }
    }
  }

  // 提示訊息顯示
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("確定"),
            ),
          ],
        );
      },
    );
  }
}
