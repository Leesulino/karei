import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'start_screen.dart';

void main() {
  runApp(const KaireidoScopeApp());
}

class KaireidoScopeApp extends StatefulWidget {
  const KaireidoScopeApp({super.key});

  @override
  State<KaireidoScopeApp> createState() => _KaireidoScopeAppState();
}

class _KaireidoScopeAppState extends State<KaireidoScopeApp> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startBGM();
  }

  Future<void> _startBGM() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('back.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

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
