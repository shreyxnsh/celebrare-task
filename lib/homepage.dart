import 'dart:io';
import 'dart:typed_data';

import 'package:celebrare/shapes/circle.dart';
import 'package:celebrare/shapes/heart.dart';
import 'package:celebrare/shapes/round_rectangle.dart';
import 'package:celebrare/shapes/square.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'image_crop.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Container(
          child: ElevatedButton(
            child: const Text("Choose"),
            onPressed: () async {
              ImagePicker imagepicker = ImagePicker();
              final image = await imagepicker.pickImage(source: ImageSource.gallery);

              File fileimage = File(image!.path);
              final decode = await decodeImageFromList(fileimage.readAsBytesSync());
              print("${decode.width}  ${decode.height}");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImageCrop(
                        imagepath: image.path,
                        width: decode.width,
                        height: decode.height,
                      )));
              // imagepicker.pickImage(source: source)
            },
          ),
        ),
        image != null ? Image.memory(image!) : Container(),
        LayoutBuilder(builder: (context, size) {
          print(size.biggest);
          return Container(
            padding: const EdgeInsets.all(20),
            width: size.maxWidth,
            height: size.maxWidth,
            child: CustomPaint(
              painter: Circle(),
            ),
          );
        })
      ]),
    );
  }
}
