import 'package:flutter/material.dart';
import 'result_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/1.png',
              fit: BoxFit.cover, // 꽉 차게
            ),
          ),

          // 로고
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
          ),

          // START 버튼
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultScreen()),
                  );
                },
                child: Image.asset(
                  'assets/buttonon.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
