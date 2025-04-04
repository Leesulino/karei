import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Duration duration; // ✅ 추가

  const GlowingButton({
    Key? key,
    required this.imagePath,
    required this.onTap,
    this.width = 200,
    this.height = 80,
    this.duration = const Duration(milliseconds: 100), // ✅ 기본값
  }) : super(key: key);

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: widget.duration, // ✅ 외부에서 조절 가능
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.contain,
            colorFilter:
                _isPressed
                    ? const ColorFilter.mode(Colors.white, BlendMode.screen)
                    : null,
          ),
          boxShadow:
              _isPressed
                  ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.8),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                  : [],
        ),
      ),
    );
  }
}
