import 'package:flutter/material.dart';
import 'custom_button.dart';

class WakuScreen extends StatelessWidget {
  final int candleCount;
  final String dialogue;
  final int setunaExpression;
  final bool isLoading;
  final bool showNoro;
  final String? imagePath;
  final VoidCallback onEmotionTap;
  final VoidCallback onRetryTap;
  final VoidCallback onPickImage;
  final VoidCallback onDismissNoro; // 콜백 추가

  const WakuScreen({
    super.key,
    required this.candleCount,
    required this.dialogue,
    required this.setunaExpression,
    required this.isLoading,
    required this.showNoro,
    required this.imagePath,
    required this.onEmotionTap,
    required this.onRetryTap,
    required this.onPickImage,
    required this.onDismissNoro, // 콜백 추가
  });

  // ... (기존 UI 코드 동일)

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // (배경, 와꾸, 캐릭터, 대사창, 감정버튼 등 기존 코드 생략)

        // 🔴 노로 효과: 콜백 호출
        if (showNoro)
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismissNoro, // 이걸로 처리!
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/noro.png', fit: BoxFit.cover),
              ),
            ),
          ),
      ],
    );
  }
}
