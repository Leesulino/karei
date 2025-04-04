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
                  width: MediaQuery.of(context).size.width * 0.65, // 더 큼
                  duration: const Duration(milliseconds: 200), // 연출 빠르게
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
