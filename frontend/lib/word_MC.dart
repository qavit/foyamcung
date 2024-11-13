import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordMultipleChoiceGame extends StatefulWidget {
  const WordMultipleChoiceGame({super.key});

  @override
  _WordMultipleChoiceGameState createState() => _WordMultipleChoiceGameState();
}

class _WordMultipleChoiceGameState extends State<WordMultipleChoiceGame> {
  String question = '';
  List<String> options = [];
  int health = 5;
  int experience = 0;
  bool showInfoDialog = false;
  int correctAnswerIndex = 0;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    fetchWordData();
  }

  Future<void> fetchWordData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/words/questionList'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          question = data['question'];
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
            if (showInfoDialog) _buildInfoDialog(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('❤️ 生命值: $health', style: const TextStyle(fontSize: 18)),
                Text('EXP: $experience', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '客語單字: $question',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
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
                        _checkAnswer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAnswerIndex == index
                            ? Colors.teal[200]
                            : Colors.grey,
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
        health = 5;
        experience = 0;
      } else {
        _showMessage("錯誤，正確答案為：${options[correctAnswerIndex]}");
      }
    }
  }

  void _loadNewWord() {
    fetchWordData();
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
                _loadNewWord();
              },
              child: const Text("確定"),
            ),
          ],
        );
      },
    );
  }
} 