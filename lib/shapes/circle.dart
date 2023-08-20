import 'package:flutter/material.dart';

class CircleClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
          const Radius.circular(100)));
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

class Circle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
