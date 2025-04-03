import 'package:flutter/material.dart';
import 'start_screen.dart';

void main() {
  runApp(const KaireidoScopeApp());
}

class KaireidoScopeApp extends StatelessWidget {
  const KaireidoScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAIREIDO SCOPE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StartScreen(),
    );
  }
}
