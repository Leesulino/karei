import 'package:flutter/material.dart';

class DialogueBox extends StatelessWidget {
  final String text;

  const DialogueBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        // 말풍선 배경
        Image.asset(
          'assets/waku.png',
          width: MediaQuery.of(context).size.width * 0.9,
        ),

        // 텍스트
        Positioned(
          top: 20,
          left: 30,
          right: 20,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
