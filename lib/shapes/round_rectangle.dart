import 'package:flutter/material.dart';

class RoundRectangleClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..addRRect(
      RRect.fromRectXY(
          Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height * 0.6), 5, 5),
    );

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RoundRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height * 0.6), 5, 5),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
