import 'package:flutter/material.dart';
import 'waku_screen.dart';

class ResultScreen extends StatefulWidget {
  final String? imagePath;

  ResultScreen({this.imagePath});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = false;
  bool showNoro = false;
  int candleCount = 3;
  String dialogue = "セツナです。鑑定を始めてください。";
  int setunaExpression = 0;
  String? selectedImage;

  void _retrySession() {
    setState(() {
      candleCount = 3;
      dialogue = "セツナです。鑑定を始めてください。";
      isLoading = false;
      showNoro = false;
      setunaExpression = 0;
    });
  }

  void _startLoadingAndEmotion() async {
    setState(() {
      isLoading = true;
      showNoro = false;
      dialogue = "鑑定中……";
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
      candleCount--;
      showNoro = (candleCount == 1);
      dialogue =
          candleCount == 2
              ? "これはただの古いトンネルですね。"
              : candleCount == 1
              ? "……何か感じました。ここは危ないかも。"
              : "これ以上鑑定できません。広告をご覧ください。";
      setunaExpression = 3 - candleCount;
    });
  }

  void _pickImage() {
    print("이미지 선택 triggered (추후 구현)");
    // selectedImage = ...
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
        imagePath: selectedImage,
        onEmotionTap: _startLoadingAndEmotion,
        onRetryTap: _retrySession,
        onPickImage: _pickImage,
      ),
    );
  }
}
