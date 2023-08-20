import 'package:flutter/material.dart';

class HeartClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width * 0.85, size.height / 2);
    path.cubicTo(
      size.width,
      size.height * 0.175,
      size.width * 0.75,
      0,
      size.width * 0.5,
      size.height * 0.25,
    );
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width * 0.15, size.height / 2);
    path.cubicTo(
      0,
      size.height * 0.125,
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.25,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Heart extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width * 0.85, size.height / 2);
    path.cubicTo(
      size.width,
      size.height * 0.175,
      size.width * 0.75,
      0,
      size.width * 0.5,
      size.height * 0.25,
    );
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width * 0.15, size.height / 2);
    path.cubicTo(
      0,
      size.height * 0.125,
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.25,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
