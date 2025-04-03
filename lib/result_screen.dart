import 'package:flutter/material.dart';
import 'candle_widget.dart';
import 'dialogue_box.dart';

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
  String dialogue = "세츠나입니다. 감정을 시작해주세요.";
  int setunaExpression = 0;

  void _startLoadingAndEmotion() async {
    setState(() {
      isLoading = true;
      showNoro = false;
      dialogue = "감정 중...";
    });

    await Future.delayed(Duration(seconds: 3)); // 로딩 시뮬레이션

    setState(() {
      isLoading = false;
      candleCount--;
      showNoro = (candleCount == 1); // 촛불 1개 남았을 때 노로 발동
      dialogue =
          candleCount == 2
              ? "이건 그냥 낡은 터널이에요."
              : candleCount == 1
              ? "……뭔가 느껴졌어요. 여긴 위험할지도."
              : "더 이상 감정할 수 없어요. 광고를 보세요.";
      setunaExpression = 1 + (3 - candleCount);
    });
  }

  void _pickImage() {
    // 이미지 피커 호출용, 실제 구현은 Flutter 웹/모바일마다 다름
    print("이미지 선택 triggered (추후 구현)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (widget.imagePath != null)
            Center(
              child: Image.asset(
                widget.imagePath!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),

          // 확대경 (이미지 선택 전용)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: GestureDetector(
              onTap: _pickImage,
              child: Image.asset('assets/candlescope.png', width: 150),
            ),
          ),

          // 감정 시작 버튼
          if (!isLoading && candleCount > 0)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _startLoadingAndEmotion,
                  child: Image.asset('assets/kansei.png', width: 120),
                ),
              ),
            ),

          // 로딩 중
          if (isLoading)
            Center(child: Image.asset('assets/loading.png', width: 150)),

          // 세츠나 캐릭터 + 대사창
          Positioned(
            bottom: 120,
            left: 20,
            child: Image.asset(
              'assets/setuna_var.png',
              width: 100,
              height: 100,
            ),
          ),
          DialogueBox(text: dialogue),

          // 촛불
          Positioned(
            top: 40,
            right: 20,
            child: CandleWidget(remaining: candleCount, total: 3),
          ), // ← 이 괄호가 누락되어 있었음!
          if (showNoro)
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/noro.png', fit: BoxFit.cover),
              ),
            ),
        ],
      ),
    );
  }
}
