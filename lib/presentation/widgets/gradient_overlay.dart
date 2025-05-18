import 'package:flutter/material.dart';

/// A widget that applies gradient overlays to the top and bottom of its parent.
///
/// Creates a stack with two positioned containers that have gradient decorations:
/// - A top gradient that fades from black (with 54% opacity) to transparent from top to bottom
/// - A bottom gradient that fades from transparent to black (with 54% opacity) from top to bottom
///
/// Each gradient has a fixed height of 100 logical pixels.
///
/// Typically used to improve text readability when overlaid on images or videos
/// by creating subtle darkening effects at the edges.
///
/// Example usage:
/// ```dart
/// Stack(
///   children: [
///     Image.asset('background.jpg'),
///     GradientOverlay(),
///     Text('Content is now more readable'),
///   ],
/// )
/// ```
class GradientOverlay extends StatelessWidget {
  const GradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
