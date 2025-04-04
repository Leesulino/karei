import 'package:flutter/material.dart';
import 'candle_widget.dart';
import 'dialogue_box.dart';
import 'custom_button.dart'; // GlowingButton 위젯 사용

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
  void _retrySession() {
    setState(() {
      candleCount = 3;
      dialogue = "세츠나입니다. 감정을 시작해주세요.";
      isLoading = false;
      showNoro = false;
      setunaExpression = 0;
    });
  }

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
      showNoro = (candleCount == 1);
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
    // 이미지 선택 기능은 플랫폼별 구현 필요
    print("이미지 선택 triggered (추후 구현)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 배경 이미지 (가장 아래)
          Positioned.fill(
            child: Image.asset('assets/2.png', fit: BoxFit.cover),
          ),

          // 🔁 촛불 다 꺼졌을 때 리트라이 버튼 추가
          if (candleCount == 0 && !isLoading)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GlowingButton(
                  imagePath: 'assets/retry.png',
                  width: 180,
                  onTap: _retrySession,
                ),
              ),
            ),

          // 🖼️ 선택된 이미지 (임시)
          if (widget.imagePath != null)
            Center(
              child: Image.asset(
                widget.imagePath!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),

          // 🔍 확대경 버튼
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: GestureDetector(
              onTap: _pickImage,
              child: Image.asset('assets/candlescope.png', width: 150),
            ),
          ),

          // 🔮 감정 버튼
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
          // 🔁 리트라이 버튼 (감정 다 했을 때)
          if (candleCount == 0 && !isLoading)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GlowingButton(
                  imagePath: 'assets/retry.png',
                  width: 180,
                  onTap: _retrySession,
                ),
              ),
            ),

          // ⏳ 로딩 이미지
          if (isLoading)
            Center(child: Image.asset('assets/loading.png', width: 150)),

          // 🧍‍♀️ 세츠나 캐릭터
          Positioned(
            bottom: 120,
            left: 20,
            child: Image.asset(
              'assets/setuna_var.png',
              width: 100,
              height: 100,
            ),
          ),

          // 💬 대사창
          DialogueBox(text: dialogue),

          // 🕯️ 촛불 위젯 (하나만 남기기)
          Positioned(
            top: 40,
            right: 20,
            child: CandleWidget(remaining: candleCount, total: 3),
          ),

          // 🩸 노로 효과 (한 번만)
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
