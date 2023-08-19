import 'dart:io';
import 'dart:math';
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
  late double imageX, imageY, posX = -1, posY = -1, conX = 300, conY = 300;
  Uint8List? imagelist;
  img.Image? image;
  RenderBox? imagebox;

  GlobalKey imagekey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      imagebox = ((imagekey.currentContext!.findRenderObject() as RenderBox));
      image = await img.decodeImageFile(widget.imagepath);
      imagelist = img.encodePng(image!);
      setState(() {
        getLocations();
      });
    });
  }

  void getLocations() async {
    final Offset imageoffset = imagebox!.localToGlobal(Offset.zero);
    print(imageoffset);
    imageX = imageoffset.dx;
    imageY = imageoffset.dy;
    posY = imageoffset.dy;
    posX = imageoffset.dx;
  }

  @override
  Widget build(BuildContext context) {
    // posY = 100;
    return LayoutBuilder(builder: (context, sizebox) {
      return Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.rotate_right_outlined, color: Colors.white)),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  image = img.flipVertical(image!);
                                  imagelist = img.encodePng(image!);
                                });
                              },
                              child: const Text(
                                "Vertical Flip",
                                // style: TextStyle(color: Colors.white),
                              ))),
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  image = img.flipHorizontal(image!);
                                  imagelist = img.encodePng(image!);
                                });
                              },
                              child: const Text(
                                "Horizontal Flip",
                                // style: TextStyle(color: Colors.white),
                              ))),
                    ],
                    icon: const Icon(
                      Icons.flip_camera_ios_sharp,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "CROP",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              floatingActionButton: FloatingActionButton(onPressed: () async {
                // final image = await img.decodeImageFile(widget.imagepath);
                final croppedImage = img.copyCrop(image!,
                    x: (widget.width * (posX - imageX) ~/ imagebox!.size.width),
                    y: (widget.height * (posY - imageY) ~/ imagebox!.size.height),
                    width: widget.width * conX ~/ imagebox!.size.width,
                    height: widget.height * conY ~/ imagebox!.size.height);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.memory(img.encodePng(croppedImage)),
                      );
                    });
              }),
              body: Center(
                child: imagelist == null
                    ? Image(
                        image: FileImage(File(widget.imagepath)),
                        key: imagekey,
                      )
                    : Image.memory(imagelist!),
              )),
          Positioned(
            left: posX == -1 ? (sizebox.maxWidth / 2) - (conX / 2) : posX,
            top: posY == -1 ? (sizebox.maxWidth / 2) - (conY / 2) : posY,
            child: Container(
              color: Colors.transparent.withOpacity(0.1),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: conY,
                    width: conX,
                    child: CustomPaint(
                      painter: CornersPainter(),
                    ),
                  ),
                  GestureDetector(
                    onPanUpdate: (details) {
                      // print("$imageX $imageY");
                      setState(() {
                        posX += details.delta.dx;
                        posY += details.delta.dy;

                        if (posX < imageX) posX = imageX;
                        if (posY < imageY) posY = imageY;

                        // print("${imagebox!.size.width + imageX - con} ${imagebox!.size.height + imageY - con}");
                        if (posX + conX > imageX + imagebox!.size.width) posX = imageX + imagebox!.size.width - conX;
                        if (posY + conY > imageY + imagebox!.size.height) posY = imageY + imagebox!.size.height - conY;
                      });
                      // print(details.localPosition.distance);
                      // print("$posX+ +$posY");
                    },
                    child: Container(
                      // color: Colors.red,
                      decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.red), color: Colors.transparent),
                      width: conX,
                      height: conY,
                    ),
                  ),
                  SizedBox(
                    height: conY,
                    width: conX,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (details) {
                              setState(() {
                                conX -= details.delta.dx;
                                conY -= details.delta.dy;
                                posX += details.delta.dx;
                                posY += details.delta.dy;

                                if (conX < 100) conX = 100;
                                if (conY < 100) conY = 100;
                                if (posX < imageX) posX = imageX;
                                if (posY < imageY) posY = imageY;

                                // print("${imagebox!.size.width + imageX - con} ${imagebox!.size.height + imageY - con}");
                                if (posX + conX > imageX + imagebox!.size.width) posX = imageX + imagebox!.size.width - conY;
                                if (posY + conY > imageY + imagebox!.size.height) posY = imageY + imagebox!.size.height - conX;
                                // changePosition(details);
                              });
                            },
                            child: const SizedBox(
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (details) {
                              print(details.delta);
                              setState(() {
                                conX += details.delta.dx;
                                conY += details.delta.dy;

                                if (conX < 100) conX = 100;
                                if (conY < 100) conY = 100;
                              });
                            },
                            child: const SizedBox(
                              height: 50,
                              width: 50,
                              // color: Colors.red,
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
      ..strokeWidth = 6;

    const double cornerLength = 20;

    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CornersPainter oldDelegate) => false;
}
