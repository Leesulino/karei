import 'package:flutter/material.dart';
import 'custom_button.dart';

class WakuScreen extends StatefulWidget {
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
  State<WakuScreen> createState() => _WakuScreenState();
}

class _WakuScreenState extends State<WakuScreen> {
  bool firstTimeGuide = true;

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

        // 촛불
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: List.generate(3, (index) {
              final isOn = index < widget.candleCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child:
                    isOn
                        ? Image.asset('assets/candle.png', width: 32)
                        : ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ]),
                          child: Image.asset('assets/candle.png', width: 32),
                        ),
              );
            }),
          ),
        ),

        // 와꾸 + 칸세이 버튼
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/waku.png', width: 360),

              // 감정 버튼 (클릭 가능)
              if (!widget.isLoading)
                Positioned(
                  top: 24,
                  child: GestureDetector(
                    onTap: () {
                      widget.onPickImage();
                      setState(() => firstTimeGuide = false);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          widget.candleCount > 0
                              ? 'assets/kansei.png'
                              : 'assets/kansei_grey.png',
                          width: 180,
                        ),
                        if (widget.candleCount > 0 && firstTimeGuide)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.3, end: 0.9),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.rotate(
                                angle: -0.2,
                                child: Opacity(
                                  opacity: value,
                                  child: Image.asset(
                                    'assets/scope.png',
                                    width: 72,
                                  ),
                                ),
                              );
                            },
                            onEnd: () => setState(() => firstTimeGuide = false),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 세츠나 (왼쪽 하단)
        Positioned(
          bottom: 90,
          left: 20,
          child: Stack(
            children: [
              Image.asset(
                'assets/setuna.png',
                width: 300,
                height: 300,
                filterQuality: FilterQuality.none,
              ),
              if (!widget.isLoading &&
                  widget.candleCount > 0 &&
                  widget.setunaExpression != 0)
                Image.asset(
                  'assets/setuna_var_aligned_${widget.setunaExpression}.png',
                  width: 300,
                  height: 300,
                  filterQuality: FilterQuality.none,
                ),
            ],
          ),
        ),

        // 대사창 (buttonoff)
        Positioned(
          bottom: 10,
          left: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/buttonoff.png', width: 260),
              SizedBox(
                width: 220,
                child: Text(
                  widget.dialogue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'DotGothic16',
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),

        // 리트라이 버튼
        if (!widget.isLoading && widget.candleCount == 0)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: GlowingButton(
                imagePath: 'assets/retry.png',
                width: 200,
                height: 80,
                onTap: widget.onRetryTap,
              ),
            ),
          ),

        // 로딩 애니
        if (widget.isLoading)
          Center(
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
                          child: Image.asset(
                            'assets/loading_red.png',
                            width: 150,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        // 노로 발동
        if (widget.showNoro)
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onDismissNoro,
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
