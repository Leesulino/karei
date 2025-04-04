import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'waku_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int candleCount = 3;
  String dialogue = "ここに感情の結果が表示されます。";
  int setunaExpression = 0; // 0 = 기본, 1~4 = 표정
  bool isLoading = false;
  bool showNoro = false;
  String? imagePath;

  Future<void> onPickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        isLoading = true;
        setunaExpression = 0; // 로딩 중엔 디폴트 표정
      });

      await Future.delayed(const Duration(seconds: 3)); // 감정 처리 시뮬레이션

      setState(() {
        isLoading = false;
        setunaExpression = (candleCount % 4) + 1; // 1~4 표정
        dialogue = _getDialogue(setunaExpression);
        candleCount = (candleCount - 1).clamp(0, 3);
      });
    }
  }

  void _retrySession() {
    setState(() {
      candleCount = 1;
      imagePath = null;
      isLoading = false;
      setunaExpression = 0;
      dialogue = "もう一度感じてみましょう。";
    });
  }

  String _getDialogue(int expression) {
    switch (expression) {
      case 1:
        return "うーん、ちょっと怖いかも？";
      case 2:
        return "背筋がゾッとしますね…";
      case 3:
        return "これは危ない場所かも…";
      case 4:
        return "……ッ！ ここはやめましょう！";
      default:
        return "ここに感情の結果が表示されます。";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WakuScreen(
        candleCount: candleCount,
        dialogue: dialogue,
        setunaExpression: setunaExpression,
        isLoading: isLoading,
        showNoro: showNoro,
        imagePath: imagePath,
        onEmotionTap: () {}, // 현재 사용 안함
        onRetryTap: _retrySession,
        onPickImage: onPickImage,
        onDismissNoro: () => setState(() => showNoro = false),
      ),
    );
  }
}
