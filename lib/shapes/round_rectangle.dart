import 'package:flutter/material.dart';

class RoundRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    print(size);
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: size.width * 0.8,
                height: size.height * 0.8),
            20,
            20),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
