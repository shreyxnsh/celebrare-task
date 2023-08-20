import 'package:flutter/material.dart';

class SquareClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(RRect.fromRectXY(
          Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width * 0.8, height: size.height * 0.8), 5, 5));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Square extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width * 0.8, height: size.height * 0.8),
            5,
            5),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
