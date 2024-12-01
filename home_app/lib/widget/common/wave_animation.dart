import 'package:flutter/material.dart';

class EmittingWave extends StatefulWidget {
  final Color color;

  const EmittingWave({super.key, required this.color});

  @override
  State<EmittingWave> createState() => _EmittingWaveState();
}

class _EmittingWaveState extends State<EmittingWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 100 * _animation.value,
          height: 100 * _animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(1 - _animation.value),
          ),
        );
      },
    );
  }
}
