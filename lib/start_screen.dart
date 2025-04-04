import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'custom_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/1.png', fit: BoxFit.cover),
          ),

          // 로고를 세츠나 얼굴 아래쯤 고정
          Positioned(
            top: 240, // ← 이 값으로 미세조정 가능
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),

          // START 버튼은 아래쪽에 고정
          Positioned(
            bottom: 100, // ← 버튼 위치 고정
            left: 0,
            right: 0,
            child: Center(
              child: GlowingButton(
                imagePath: 'assets/start.png',
                width: 222,
                height: 222,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
