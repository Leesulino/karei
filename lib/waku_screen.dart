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
        Image.asset(
          'assets/2.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // 선택된 이미지 (optional)
        if (imagePath != null)
          Center(
            child: Image.asset(
              imagePath!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

        // 확대경 버튼 (이미지 선택)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: MediaQuery.of(context).size.width * 0.25,
          child: GestureDetector(
            onTap: onPickImage,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topRight,
                widthFactor: 0.5,
                child: Image.asset('assets/candlescope.png', width: 100),
              ),
            ),
          ),
        ),

        // waku 영역
        Center(
          child: Stack(
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
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    dialogue,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontFamily: 'DotGothic16',
                    ),
                  ),
                ),
              ),

              // 감정 버튼 or 리트라이 버튼
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child:
                      isLoading
                          ? const SizedBox.shrink()
                          : candleCount > 0
                          ? GestureDetector(
                            onTap: onEmotionTap,
                            child: Image.asset('assets/kansei.png', width: 100),
                          )
                          : GlowingButton(
                            imagePath: 'assets/retry.png',
                            width: 120,
                            onTap: onRetryTap,
                          ),
                ),
              ),
            ],
          ),
        ),

        // 촛불
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: List.generate(3, (index) {
              final isOn = index < candleCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isOn ? Colors.transparent : Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      widthFactor: 0.5,
                      child: Image.asset('assets/candlescope.png', width: 30),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // 로딩 중
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
    );
  }
}
