import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transitions personnalisées pour go_router.
abstract final class AppTransitions {

  /// Transition en fondu — pour les écrans principaux.
  static Page<T> fade<T>({
    required LocalKey       key,
    required Widget         child,
    Duration                duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key:             key,
      child:           child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child:   child,
        );
      },
    );
  }

  /// Transition slide depuis le bas — pour les modales.
  static Page<T> slideUp<T>({
    required LocalKey key,
    required Widget   child,
  }) {
    return CustomTransitionPage<T>(
      key:   key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end:   Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve:  Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }
}