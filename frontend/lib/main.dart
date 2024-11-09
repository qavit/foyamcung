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
        cardColor: Colors.lightBlueAccent.shade100, // 主題顏色
      ),
      home: SentenceArrangementGame(),
    );
  }
}

class SentenceArrangementGame extends StatefulWidget {
  @override
  _SentenceArrangementGameState createState() =>
      _SentenceArrangementGameState();
}

class _SentenceArrangementGameState extends State<SentenceArrangementGame> {
  List<String> hakkaWords = [];
  List<String> correctOrder = [];
  String chineseSentence = ""; // 華語例句
  int health = 5; // 初始生命值
  int experience = 0; // 初始經驗值

  @override
  void initState() {
    super.initState();
    fetchSentenceData();
  }

  // 更新的 fetchSentenceData 函式
  Future<void> fetchSentenceData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/sentences/'));
    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes); // 解碼成 UTF-8
      var data = json.decode(utf8Response)[0];

      setState(() {
        chineseSentence = data['chinese_sentence'];
        hakkaWords = List<String>.from(data['hakka_words']);
        correctOrder = List<String>.from(data['hakka_words']); // 正確順序
      });
    } else {
      print("Error fetching sentences: ${response.statusCode}");
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
              '$chineseSentence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // 客語字卡區域
            // Text('拖曳字卡排列成正確的客語順序:', style: TextStyle(fontSize: 16)),
            // SizedBox(height: 10),
            Expanded(
              child: Wrap(
                spacing: 8.0, // 卡片之間的水平間距
                runSpacing: 8.0, // 行之間的垂直間距
                children: hakkaWords.map((word) {
                  return DraggableCard(
                    word: word,
                    color: Theme.of(context).cardColor,
                  );
                }).toList(),
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

  // 確認答案
  void _checkAnswer() {
    if (hakkaWords.join() == correctOrder.join()) {
      // 排列正確
      setState(() {
        experience += 10; // 增加經驗值
      });
      if (experience >= 100) {
        _showMessage("恭喜過關！");
      } else {
        _showMessage("正確！");
      }
    } else {
      // 排列錯誤
      setState(() {
        health -= 1; // 減少生命值
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

// 定義圓角的 DraggableCard 小部件
class DraggableCard extends StatelessWidget {
  final String word;
  final Color color;

  const DraggableCard({required this.word, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10), // 圓角矩形
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Text(
        word,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
