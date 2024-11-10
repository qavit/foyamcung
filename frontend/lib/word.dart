// main.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WordLearningApp());
}

class WordLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '單字選擇遊戲',
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
      home: WordSelectionGame(),
    );
  }
}

class WordSelectionGame extends StatefulWidget {
  @override
  _WordSelectionGameState createState() =>
      _WordSelectionGameState();
}

class _WordSelectionGameState extends State<WordSelectionGame> {
  String quesiton = '';
  List<String> options = [];
  int health = 5;
  int experience = 0;
  bool showInfoDialog = false;
  int correctAnswerIndex = 0; // 正確答案的索引
  int? selectedAnswerIndex; // 使用者選擇的答案索引

  @override
  void initState() {
    super.initState();
    fetchWordData();
  }

  Future<void> fetchWordData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/words/questionList'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          quesiton = data['question'];
          options = List<String>.from(data['options']);
          correctAnswerIndex = data['correct_answer_index'];
        });
      } else {
        throw Exception('Failed to load words');
      }
    } catch (error) {
      print('Error fetching words: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('單字選擇遊戲'),
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
            // 客語單字展示
            Center(
              child: Text(
                '客語單字: $quesiton',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            // 客語字卡區域
            Expanded(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedAnswerIndex = index;
                        });
                        _checkAnswer(); // 選擇答案後立即檢查答案
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAnswerIndex == index
                            ? Colors.teal[200]
                            : Colors.grey, // 選擇時顯示不同顏色
                      ),
                      child: Text(option),
                    ),
                  );
                }).toList(),
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }


  // 彈跳窗格 - 顯示題目說明
  Widget _buildInfoDialog() {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      content: Text(
        '題目說明：根據問題選擇正確的配對',
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
  if (selectedAnswerIndex == correctAnswerIndex) {
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
      health = 5; // 重新開始
      experience = 0;
    } else {
      _showMessage("錯誤，正確答案為：${options[correctAnswerIndex]}");
    }
  }
}

  void _loadNewWord() {
    fetchWordData(); // 隨機出新題目
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
                    selectedAnswerIndex = null;
                    _loadNewWord(); // 按下確定再重新出題
              },
              child: const Text("確定"),
            ),
          ],
        );
      },
    );
  }
}
