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

        // 선택한 이미지 미리보기
        if (imagePath != null)
          Center(
            child: Image.asset(
              imagePath!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

        // 촛불 UI
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: List.generate(3, (index) {
              final isOn = index < candleCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: isOn
                    ? Image.asset('assets/candle.png', width: 32)
                    : ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0, 0, 0, 1, 0,
                        ]),
                        child: Image.asset('assets/candle.png', width: 32),
                      ),
              );
            }),
          ),
        ),

        // Waku 및 내부 요소
        Center(
          child: Stack(
            children: [
              Image.asset('assets/waku.png', width: 400),

              // 세츠나 (기본 + 표정 겹침)
              Positioned(
                bottom: 100,
                left: 40,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/setuna.png',
                      width: 300,
                      height: 300,
                      filterQuality: FilterQuality.none,
                    ),
                    if (!isLoading && candleCount > 0 && setunaExpression != 0)
                      Image.asset(
                        'assets/setuna_var_aligned_$setunaExpression.png',
                        width: 300,
                        height: 300,
                        filterQuality: FilterQuality.none,
                      ),
                  ],
                ),
              ),

              // 대사창
              Positioned(
                bottom: 20,
                right: 30,
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

              // 감정 버튼 (kansei)
              if (!isLoading)
                Positioned(
                  top: 16,
                  left: 100,
                  right: 100,
                  child: GestureDetector(
                    onTap: onPickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          candleCount > 0
                              ? 'assets/kansei.png'
                              : 'assets/kansei_grey.png',
                          width: 240,
                        ),
                        if (candleCount > 0)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.3, end: 0.9),
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Image.asset(
                                  'assets/scope.png',
                                  width: 240,
                                ),
                              );
                            },
                            onEnd: () {
                              // Loop 애니메이션
                            },
                          ),
                      ],
                    ),
                  ),
                ),

              // 리트라이 버튼
              if (!isLoading && candleCount == 0)
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GlowingButton(
                      imagePath: 'assets/retry.png',
                      width: 200,
                      height: 80,
                      onTap: onRetryTap,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 로딩 애니
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

        // 노로 발동
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
