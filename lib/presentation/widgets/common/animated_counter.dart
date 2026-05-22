import 'package:flutter/material.dart';

/// Affiche un nombre avec une animation de comptage.
///
/// Utilisé pour les montants dans le dashboard.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
  });

  final double     value;
  final TextStyle  style;
  final String     prefix;
  final String     suffix;
  final Duration   duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>   _animation;
  double                   _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0,
      end:   widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve:  Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end:   widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve:  Curves.easeOutCubic,
      ));
      _controller
        ..reset()
        ..forward();
    }
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
      builder:   (context, child) {
        return Text(
          '${widget.prefix}${_animation.value.toStringAsFixed(0)}'
          '${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}