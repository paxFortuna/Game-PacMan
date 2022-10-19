import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final color;
  final child;

  const MyPixel({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        color: color,
        child: Center(child: child),
      ),
    );
  }
}
