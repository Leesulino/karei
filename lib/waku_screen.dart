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
  final VoidCallback onDismissNoro;

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
    required this.onDismissNoro,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경
        Image.asset(
          'assets/2.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // 이미지 미리보기
        if (imagePath != null)
          Center(
            child: Image.asset(
              imagePath!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

        // 돋보기 버튼 (waku 위로)
        Positioned(
          top: 10,
          left: 10,
          child: GestureDetector(
            onTap: onPickImage,
            child: Image.asset('assets/candlescope.png', width: 60),
          ),
        ),

        // 촛불 UI
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: List.generate(3, (index) {
              final isOn = index < candleCount;
              Widget candle = Image.asset(
                'assets/candlescope.png',
                width: 30,
                fit: BoxFit.none,
                alignment: Alignment.topLeft,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: 100 / 511,
                    heightFactor: 150 / 1024,
                    child: isOn
                        ? candle
                        : ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0, 0, 0, 1, 0,
                            ]),
                            child: candle,
                          ),
                  ),
                ),
              );
            }),
          ),
        ),

        // 와꾸 및 내부 요소
        Center(
          child: Stack(
            children: [
              Image.asset('assets/waku.png', width: 400),

              // 감정 버튼
              if (!isLoading && candleCount > 0)
                Positioned(
                  top: 16,
                  left: 100,
                  right: 100,
                  child: GestureDetector(
                    onTap: onEmotionTap,
                    child: ColorFiltered(
                      colorFilter: candleCount == 0
                          ? const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0, 0, 0, 1, 0,
                            ])
                          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                      child: Image.asset('assets/kansei.png', width: 240),
                    ),
                  ),
                ),

              // 리트라이 버튼
              if (!isLoading && candleCount == 0)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GlowingButton(
                      imagePath: 'assets/retry.png',
                      width: 180,
                      onTap: onRetryTap,
                    ),
                  ),
                ),

              // 세츠나 표정 출력
              Positioned(
                bottom: 70,
                left: 20,
                child: candleCount == 3
                    ? Image.asset('assets/setuna.png', width: 100, height: 150)
                    : ClipRect(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 100,
                            height: 150,
                            child: Image.asset(
                              'assets/setuna_var.png',
                              width: 200,
                              height: 300,
                              fit: BoxFit.none,
                              alignment: {
                                1: Alignment(1.0, -1.0), // 걱정
                                2: Alignment(-1.0, 1.0), // 슬픔
                                3: Alignment(1.0, 1.0),  // 절망
                              }[setunaExpression] ?? Alignment(-1.0, -1.0), // 미소
                            ),
                          ),
                        ),
                      ),
              ),

              // 대사창
              Positioned(
                bottom: 10,
                right: 20,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 230),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    dialogue,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontFamily: 'DotGothic16',
                    ),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 로딩 애니메이션
        if (isLoading)
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 75,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset('assets/loading.png', width: 150),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: value,
                          child: Image.asset('assets/loading_red.png', width: 150),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        // 노로 효과
        if (showNoro)
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismissNoro,
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
