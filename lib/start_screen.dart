import 'package:flutter/material.dart';
import 'result_screen.dart'; // 화면 전환 연결

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 로비 배경
        Positioned.fill(
          child: Image.asset(
            'assets/1.png',
            fit: BoxFit.cover,
          ),
        ),

        // 로고
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/logo.png',
            height: 100,
          ),
        ),

        // 시작 버튼 (buttonon.png)
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResultScreen()),
                );
              },
              child: Image.asset(
                'assets/buttonon.png',
                height: 80,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
