import 'package:flutter/material.dart';

Route<T> slideFadeRoute<T>(
  Widget page, {
  Duration d = const Duration(milliseconds: 260),
}) {
  return PageRouteBuilder(
    transitionDuration: d,
    pageBuilder: (c, a, __) => page,
    transitionsBuilder: (c, a, __, child) {
      final curved = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
