import 'package:flutter/material.dart';

class Heart extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    // TODO: implement paint

    Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 2);
    path.arcToPoint(Offset(size.width / 2, size.height * 0.25),
        radius: Radius.circular(30), clockwise: false);
    path.arcToPoint(Offset(0, size.height / 2),
        radius: Radius.circular(20), clockwise: false);
    path.lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
