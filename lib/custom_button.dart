import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Duration duration;

  const GlowingButton({
    Key? key,
    required this.imagePath,
    required this.onTap,
    this.width = 200,
    this.height = 80,
    this.duration = const Duration(milliseconds: 100),
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
        duration: widget.duration,
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              width: widget.width,
              height: widget.height,
              color: _isPressed ? Colors.white.withOpacity(0.7) : null,
              colorBlendMode: BlendMode.screen,
            ),
            if (_isPressed)
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.8),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
