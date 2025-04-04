// 📦 waku_screen.dart
import 'package:flutter/material.dart';
import 'dialogue_box.dart';
import 'custom_button.dart';

class WakuScreen extends StatelessWidget {
  final int candleCount;
  final String dialogue;
  final int setunaExpression;
  final bool isLoading;
  final VoidCallback onEmotionTap;
  final VoidCallback onRetryTap;

  const WakuScreen({
    super.key,
    required this.candleCount,
    required this.dialogue,
    required this.setunaExpression,
    required this.isLoading,
    required this.onEmotionTap,
    required this.onRetryTap,
  });

  Alignment _getExpressionAlignment(int index) {
    switch (index) {
      case 1:
        return Alignment.topRight;
      case 2:
        return Alignment.bottomLeft;
      case 3:
        return Alignment.bottomRight;
      default:
        return Alignment.topLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/waku.png', width: 400),

        // 세츠나
        Positioned(
          bottom: 80,
          left: 30,
          child:
              candleCount == 3
                  ? Image.asset('assets/setuna.png', width: 100)
                  : ClipRect(
                    child: Align(
                      alignment: _getExpressionAlignment(setunaExpression),
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

        // 버튼
        if (!isLoading && candleCount > 0)
          Positioned(
            bottom: 10,
            right: 20,
            child: GestureDetector(
              onTap: onEmotionTap,
              child: Image.asset('assets/kansei.png', width: 100),
            ),
          ),

        if (candleCount == 0 && !isLoading)
          Positioned(
            bottom: 10,
            right: 20,
            child: GlowingButton(
              imagePath: 'assets/retry.png',
              width: 120,
              onTap: onRetryTap,
            ),
          ),
      ],
    );
  }
}
