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
          // 배경 이미지
          Positioned.fill(
            child: Image.asset('assets/1.png', fit: BoxFit.cover),
          ),

          // 메인 콘텐츠 (로고 + 버튼)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(height: 40),

                // START 버튼 (새 커스텀)
                GlowingButton(
                  imagePath: 'assets/start.png',
                  width: MediaQuery.of(context).size.width * 0.6,
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
