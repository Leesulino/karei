import 'package:flutter/material.dart';

class CandleWidget extends StatelessWidget {
  final int total;
  final int remaining;

  const CandleWidget({
    super.key,
    required this.total,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isOn = index < remaining;
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            isOn ? Colors.transparent : Colors.grey,
            BlendMode.saturation,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Image.asset(
              'assets/candlescope.png',
              width: 30,
            ),
          ),
        );
      }),
    );
  }
}
