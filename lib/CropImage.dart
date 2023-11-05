import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageCrop extends StatefulWidget {
  final String imagepath;

  final int width, height;

  const ImageCrop({super.key, required this.imagepath, required this.width, required this.height});

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  late double imageX, imageY, imageW, imageH, posX = -1, posY = -1, conW = 0, conH = 0;
  Uint8List? imagelist;
  img.Image? image;
  RenderBox? imagebox;

  GlobalKey imagekey = GlobalKey();

  @override
  void initState() {
    super.initState();
    imageW = widget.width.toDouble();
    imageH = widget.height.toDouble();
    Future.delayed(const Duration(seconds: 1), () async {
      imagebox = ((imagekey.currentContext!.findRenderObject() as RenderBox));
      image = await img.decodeImageFile(widget.imagepath);
      imagelist = img.encodePng(image!);
      setState(() {
        setLocations();
      });
      if (imagebox!.size.height < imagebox!.size.width) {
        conW = imagebox!.size.height * 0.8;
        conH = imagebox!.size.height * 1.2;
      } else {
        conW = imagebox!.size.width * 0.8;
        conH = imagebox!.size.width * 1.2;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setLocations() {
    final Offset imageoffset = imagebox!.localToGlobal(Offset.zero);
    imageX = imageoffset.dx;
    imageY = imageoffset.dy;
    posY = imageoffset.dy;
    posX = imageoffset.dx;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, sizebox) {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.black45,
              appBar: AppBar(
                backgroundColor: const Color(0xff0f837b),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
                actions: [
                  IconButton(
                      onPressed: imagelist == null
                          ? null
                          : () {
                              image = img.copyRotate(image!, angle: 90);
                              imagelist = img.encodePng(image!);

                              imageW = image!.width.toDouble();
                              imageH = image!.height.toDouble();
                              setState(() {});
                              Future.delayed(const Duration(milliseconds: 500), () async {
                                imagebox = ((imagekey.currentContext!.findRenderObject() as RenderBox));
                                setState(() {
                                  final Offset imageoffset = imagebox!.localToGlobal(Offset.zero);
                                  imageX = imageoffset.dx;
                                  imageY = imageoffset.dy;
                                  posY = imageoffset.dy;
                                  posX = imageoffset.dx;

                                  if (imagebox!.size.height < imagebox!.size.width) {
                                    conW = imagebox!.size.height * 0.8;
                                    conH = imagebox!.size.height * 0.8;
                                  } else {
                                    conW = imagebox!.size.width * 0.8;
                                    conH = imagebox!.size.width * 0.8;
                                  }
                                });
                              });
                            },
                      icon: const Icon(Icons.rotate_right_outlined, color: Colors.white)),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: imagelist == null
                                  ? null
                                  : () {
                                      setState(() {
                                        image = img.flipVertical(image!);
                                        imagelist = img.encodePng(image!);
                                        Navigator.pop(context);
                                      });
                                    },
                              child: const Text(
                                "Vertical Flip",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Arapey',
                                ),
                              ))),
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: imagelist == null
                                  ? null
                                  : () {
                                      setState(() {
                                        image = img.flipHorizontal(image!);
                                        imagelist = img.encodePng(image!);
                                        Navigator.pop(context);
                                      });
                                    },
                              child: const Text(
                                "Horizontal Flip",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Arapey',
                                ),
                              ))),
                    ],
                    icon: const Icon(
                      Icons.flip,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                      onPressed: imagelist == null
                          ? null
                          : () async {
                              final croppedImage = img.copyCrop(image!,
                                  x: (imageW * (posX - imageX) ~/ imagebox!.size.width),
                                  y: (imageH * (posY - imageY) ~/ imagebox!.size.height),
                                  width: imageW * conW ~/ imagebox!.size.width,
                                  height: imageH * conH ~/ imagebox!.size.height);
                              Navigator.pop(context, img.encodePng(croppedImage));
                            },
                      child: const Text(
                        "CROP",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: Center(
                child: imagelist == null
                    ? Image(
                        image: FileImage(File(widget.imagepath)),
                        key: imagekey,
                      )
                    : Image.memory(
                        imagelist!,
                        key: imagekey,
                      ),
              )),
          imagelist == null
              ? const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Positioned(
                  left: posX == -1 ? (sizebox.maxWidth / 2) - (conW / 2) : posX,
                  top: posY == -1 ? (sizebox.maxWidth / 2) - (conH / 2) : posY,
                  child: Container(
                    color: Colors.transparent.withOpacity(0.1),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: conH,
                          width: conW,
                          child: CustomPaint(
                            painter: CornersPainter(),
                          ),
                        ),
                        GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              posX += details.delta.dx;
                              posY += details.delta.dy;

                              if (posX < imageX) posX = imageX;
                              if (posY < imageY) posY = imageY;

                              if (posX + conW > imageX + imagebox!.size.width) posX = imageX + imagebox!.size.width - conW;
                              if (posY + conH > imageY + imagebox!.size.height) posY = imageY + imagebox!.size.height - conH;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), color: Colors.transparent),
                            width: conW,
                            height: conH,
                          ),
                        ),
                        SizedBox(
                          height: conH,
                          width: conW,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onPanUpdate: (details) {
                                    setState(() {
                                      if (posY > imageY) {
                                        conH -= details.delta.dy;
                                        if (conH > 20) posY += details.delta.dy;
                                      } else if (details.delta.dy > 0) {
                                        conH -= details.delta.dy;
                                        posY += details.delta.dy;
                                      }
                                      if (posX > imageX) {
                                        conW -= details.delta.dx;
                                        if (conW > 20) posX += details.delta.dx;
                                      } else if (details.delta.dx > 0) {
                                        conW -= details.delta.dx;
                                        posX += details.delta.dx;
                                      }

                                      if (conW < 20) conW = 20;
                                      if (conH < 20) conH = 20;
                                    });
                                  },
                                  child: const SizedBox(
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onPanUpdate: (details) {
                                    setState(() {
                                      if (posY + conH < imagebox!.size.height + imageY) {
                                        conH += details.delta.dy;
                                      } else if (details.delta.dy < 0) {
                                        conH += details.delta.dy;
                                      }
                                      if (posX + conW < imagebox!.size.width + imageX) {
                                        conW += details.delta.dx;
                                      } else if (details.delta.dx < 0) {
                                        conW += details.delta.dx;
                                      }

                                      if (conW < 20) conW = 20;
                                      if (conH < 20) conH = 20;
                                    });
                                  },
                                  child: const SizedBox(
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      );
    });
  }
}

class CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6.5;

    const double cornerLength = 20;

    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CornersPainter oldDelegate) => false;
}
