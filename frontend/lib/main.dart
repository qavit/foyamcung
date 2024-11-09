// main.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(HakkaLearningApp());
}

class HakkaLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '句子排列遊戲',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.teal,
        fontFamily: 'JFOpenHuninn',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          secondary: Colors.greenAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.teal[700],
        ),
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
  String chineseSentence = '';
  int health = 5;
  int experience = 0;
  bool showInfoDialog = false;

  @override
  void initState() {
    super.initState();
    fetchSentenceData();
  }

  Future<void> fetchSentenceData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/sentences/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final randomSentence = data[Random().nextInt(data.length)];
        setState(() {
          chineseSentence = randomSentence['chinese_sentence'];
          hakkaWords = List<String>.from(randomSentence['hakka_words']);
          correctOrder = List<String>.from(hakkaWords);
          hakkaWords.shuffle(); // 打亂順序
        });
      } else {
        throw Exception('Failed to load sentences');
      }
    } catch (error) {
      print('Error fetching sentences: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('句子排列遊戲'),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _toggleInfoDialog,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 彈跳窗格 - 顯示題目說明
            if (showInfoDialog) _buildInfoDialog(),
            // 生命值和經驗值
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('❤️ 生命值: $health', style: const TextStyle(fontSize: 18)),
                Text('EXP: $experience', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            // 華語例句展示
            Center(
              child: Text(
                '華語例句: $chineseSentence',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // 客語字卡區域
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: hakkaWords.asMap().entries.map((entry) {
                    int index = entry.key;
                    String word = entry.value;

                    return DragTarget<String>(
                      onAcceptWithDetails: (details) {
                        setState(() {
                          final fromIndex = hakkaWords.indexOf(details.data);
                          if (fromIndex != index) {
                            hakkaWords.removeAt(fromIndex);
                            hakkaWords.insert(index, details.data);
                          }
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Draggable<String>(
                          data: word,
                          feedback: _buildWordCard(word),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: _buildWordCard(word),
                          ),
                          child: _buildWordCard(word),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('確認答案'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCard(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        word,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  // 彈跳窗格 - 顯示題目說明
  Widget _buildInfoDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      content: Text(
        '題目說明：拖曳詞組排列成正確的客語順序',
        style: TextStyle(color: Colors.grey[800]),
      ),
    );
  }

  void _toggleInfoDialog() {
    setState(() {
      showInfoDialog = !showInfoDialog;
    });
  }

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
    _loadNewSentence(); // 正確時重新出題
  } else {
    setState(() {
      health -= 1;
    });
    if (health <= 0) {
      _showMessage("生命值耗盡，遊戲結束！");
      health = 5; // 重新開始
      experience = 0;
    } else {
      _showMessage("錯誤，正確答案為：${correctOrder.join('')}");
    }
  }
}

  void _loadNewSentence() {
    fetchSentenceData(); // 隨機出新題目
  }

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
              child: const Text("確定"),
            ),
          ],
        );
      },
    );
  }
}
