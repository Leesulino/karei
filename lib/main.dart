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

    // ✅ PostFrameCallback으로 BGM 로딩 안정화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBGM();
    });
  }

  Future<void> _startBGM() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('back.mp3'));
      print("🎵 BGM 재생 요청 성공");
    } catch (e) {
      print("❌ BGM 재생 실패: $e");
    }
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
