import 'dart:io';
import 'dart:typed_data';

import 'package:celebrare/circle.dart';
import 'package:celebrare/heart.dart';
import 'package:celebrare/rectangle.dart';
import 'package:celebrare/square.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'CropImage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Uint8List? image;

  List<Widget> radioshape = [
    Container(
      padding: const EdgeInsets.all(2),
      child: const Text(
        "Original",
        style: TextStyle(fontSize: 12),
      ),
    ),
    SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: Heart(),
      ),
    ),
    SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: Square(),
      ),
    ),
    SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: Circle(),
      ),
    ),
    SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: RoundRectangle(),
      ),
    ),
  ];
  List<CustomClipper<Path>> clippers = [
    HeartClip(),
    SquareClip(),
    CircleClip(),
    RoundRectangleClip(),
  ];

  int isselected = 0;
  bool showimage = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: null,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Add Image / Icon",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Arapey',
            )),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Upload Image",
                    style: TextStyle(fontFamily: 'Arapey'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
 style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xff0f837b)),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
 child: const Text(
    "Choose from Device",
    style: TextStyle(fontFamily: 'Arapey'),
 ),
 onPressed: () async {
    ImagePicker imagepicker = ImagePicker();
    var imagefile = await imagepicker.pickImage(source: ImageSource.gallery);
    if (imagefile != null) {
      File fileimage = File(imagefile.path);
      final decode = await decodeImageFromList(fileimage.readAsBytesSync());
      image = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ImageCrop(
                imagepath: imagefile.path,
                width: decode.width,
                height: decode.height,
              )));

      if (image != null) {
        showimage = await showDialog(
            context: context,
            builder: (context) {
              return popupConfirmation();
            });
        setState(() {});
      }
    }
 },
),
                ],
              ),
            ),
          ),
          image != null && showimage
              ? isselected == 0
                  ? Image.memory(image!)
                  : ClipPath(
                      clipper: clippers[isselected - 1],
                      child: Image.memory(image!),
                    )
              : Container(
                padding: const EdgeInsets.all(10),
              ),
        ]),
      ),
    );
  }

  Widget popupConfirmation() => StatefulBuilder(builder: (context, setState) {
  return AlertDialog(
    contentPadding: EdgeInsets.all(12), // Remove content padding
    content: IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              maxRadius: 15,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                iconSize: 10,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Margin above the "Uploaded Image" text
          const Text("Uploaded Image", style: TextStyle(fontFamily: 'Arapey', fontSize: 22, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10), // Margin below the "Uploaded Image" text
          isselected != 0
              ? ClipPath(
                  clipper: clippers[isselected - 1],
                  child: Image.memory(image!),
                )
              : Image.memory(image!),
          const SizedBox(height: 20), // Margin above the row
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              radioshape.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    isselected = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: isselected == index ? const Color(0xff0f837b) : Colors.grey),
                  ),
                  child: radioshape[index],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Margin below the row
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xff0f837b)),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth, // Set button width to maximum
                  child: const Text(
                    "Use this Image",
                    style: TextStyle(fontFamily: 'Arapey'),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          )
          
        ],
      ),
    ),
  );
});


}
