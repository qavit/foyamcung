import 'package:flutter/material.dart';

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
  List<String> hakkaWords = ["客話", "係", "吾", "阿姆話"]; // 假設的初始斷詞
  List<String> correctOrder = ["客話", "係", "吾", "阿姆話"]; // 正確答案
  int health = 5; // 初始生命值
  int experience = 0; // 初始經驗值

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
              '華語例句: 今天要學習客語。',
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
                              style: TextStyle(fontSize: 18),
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
