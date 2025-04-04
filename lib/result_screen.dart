import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'waku_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int candleCount = 3;
  String dialogue = '';
  int setunaExpression = 0;
  bool isLoading = false;
  bool showNoro = false;
  String? imagePath;
  String caption = '';
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _checkCandleReset();
  }

  Future<void> _checkCandleReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTime = prefs.getInt('lastEmotionTime') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTime > 86400000) { // 24시간 = 86400000ms
      setState(() {
        candleCount = 3;
      });
    }
  }

  void _saveLastEmotionTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastEmotionTime', DateTime.now().millisecondsSinceEpoch);
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          setState(() {
            candleCount = (candleCount + 1).clamp(0, 3);
            dialogue = 'ふたたび鑑定が可能になりました。';
            showNoro = false;
          });
          _rewardedAd = null;
          _loadRewardedAd();
        },
      );
    }
  }

  void _retrySession() {
    _showRewardedAd();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => imagePath = image.path);
    }
  }

  Future<void> _analyzeCaption() async {
    final input = _captionController.text.trim();
    if (input.isEmpty || candleCount == 0) return;

    setState(() {
      isLoading = true;
      showNoro = false;
      setunaExpression = 0;
      dialogue = '';
    });

    try {
      final uri = Uri.parse('http://YOUR_BACKEND_ADDRESS/predict');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'caption': input, 'lang': 'ja'}),
      );

      final rand = DateTime.now().millisecondsSinceEpoch % 100;
      final shouldShowNoro = rand < 25;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final expressionKeyword = data['expression'] ?? 'smile';
        final mappedExpression = _mapExpression(expressionKeyword);

        setState(() {
          isLoading = false;
          setunaExpression = mappedExpression;
          dialogue = data['message'] ?? '…';
          showNoro = shouldShowNoro;
        });

        // 감정 끝난 뒤 촛불 감소
        setState(() {
          candleCount = (candleCount - 1).clamp(0, 3);
        });

        _saveLastEmotionTime();
      } else {
        throw Exception('API 실패');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dialogue = 'エラーが発生しました。';
        setunaExpression = 4;
      });
    }
  }

  int _mapExpression(String keyword) {
    switch (keyword.toLowerCase()) {
      case 'smile':
        return 1;
      case 'worried':
        return 2;
      case 'sad':
        return 3;
      case 'scared':
      case 'despair':
        return 4;
      default:
        return 1;
    }
  }

  void _dismissNoro() {
    setState(() => showNoro = false);
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WakuScreen(
            candleCount: candleCount,
            dialogue: dialogue,
            setunaExpression: setunaExpression,
            isLoading: isLoading,
            showNoro: showNoro,
            imagePath: imagePath,
            onEmotionTap: () {},
            onRetryTap: _retrySession,
            onPickImage: _pickImage,
            onDismissNoro: _dismissNoro,
          ),
          Positioned(
            bottom: 150,
            left: 24,
            right: 24,
            child: Column(
              children: [
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: '心霊写真の説明を入力してください',
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: candleCount > 0 ? _analyzeCaption : null,
                  child: const Text('鑑定する'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
