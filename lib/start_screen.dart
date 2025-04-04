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
          // 배경: 화면에 맞춰 비율 유지하며 채움
          Positioned.fill(
            child: Image.asset('assets/1.png', fit: BoxFit.cover),
          ),

          // 로고 + 버튼
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 40),
                GlowingButton(
                  imagePath: 'assets/start.png',
                  width: MediaQuery.of(context).size.width * 0.65,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
