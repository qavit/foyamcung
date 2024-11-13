// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/sentence_structure.dart';
import 'package:frontend/word_mc.dart';

void main() {
  testWidgets('Hakka Learning App 基本導航測試', (WidgetTester tester) async {
    // 建立應用程序
    await tester.pumpWidget(const HakkaLearningApp());

    // 驗證應用程序標題
    expect(find.text('客語學習模組'), findsWidgets);

    // 點擊選單按鈕
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // 驗證抽屜選單中的遊戲選項
    expect(find.text('句子排列遊戲'), findsOneWidget);
    expect(find.text('單字選擇遊戲'), findsOneWidget);

    // 測試導航到單字選擇遊戲
    await tester.tap(find.text('單字選擇遊戲'));
    await tester.pumpAndSettle();

    // 驗證生命值和經驗值的初始狀態
    expect(find.text('❤️ 生命值: 5'), findsOneWidget);
    expect(find.text('EXP: 0'), findsOneWidget);
  });
}
