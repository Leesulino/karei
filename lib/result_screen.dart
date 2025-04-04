import 'package:flutter/material.dart';
import 'candle_widget.dart';
import 'dialogue_box.dart';
import 'custom_button.dart';

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

    await Future.delayed(Duration(seconds: 3));

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
  }

  Alignment _getExpressionAlignment(int index) {
    switch (index) {
      case 1:
        return Alignment.topRight; // 걱정
      case 2:
        return Alignment.bottomLeft; // 슬픔
      case 3:
        return Alignment.bottomRight; // 절망
      default:
        return Alignment.topLeft; // 미소
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Positioned.fill(
            child: Image.asset('assets/2.png', fit: BoxFit.cover),
          ),

          // waku UI 영역
          Center(
            child: Stack(
              children: [
                Image.asset('assets/waku.png', width: 400),

                // 세츠나 표정
                Positioned(
                  bottom: 80,
                  left: 30,
                  child:
                      candleCount == 3
                          ? Image.asset('assets/setuna.png', width: 100)
                          : ClipRect(
                            child: Align(
                              alignment: _getExpressionAlignment(
                                setunaExpression,
                              ),
                              widthFactor: 100 / 200,
                              heightFactor: 150 / 300,
                              child: Image.asset(
                                'assets/setuna_var.png',
                                width: 200,
                                height: 300,
                              ),
                            ),
                          ),
                ),

                // 대사창
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: DialogueBox(text: dialogue),
                ),

                // 감정 버튼 (촛불 남아있을 때만)
                if (!isLoading && candleCount > 0)
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: GestureDetector(
                      onTap: _startLoadingAndEmotion,
                      child: Image.asset('assets/kansei.png', width: 80),
                    ),
                  ),

                // 리트라이 버튼
                if (candleCount == 0 && !isLoading)
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: GlowingButton(
                      imagePath: 'assets/retry.png',
                      width: 120,
                      onTap: _retrySession,
                    ),
                  ),
              ],
            ),
          ),

          // 확대경 버튼
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: GestureDetector(
              onTap: _pickImage,
              child: Image.asset('assets/candlescope.png', width: 150),
            ),
          ),

          // 선택된 이미지 (임시)
          if (widget.imagePath != null)
            Center(
              child: Image.asset(
                widget.imagePath!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),

          // 촛불
          Positioned(
            top: 40,
            right: 20,
            child: CandleWidget(remaining: candleCount, total: 3),
          ),

          // 로딩
          if (isLoading)
            Center(child: Image.asset('assets/loading.png', width: 150)),

          // 노로 효과
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
