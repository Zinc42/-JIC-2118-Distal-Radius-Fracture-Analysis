import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageEditScreen extends StatefulWidget {
  final String imagePath;

  const ImageEditScreen({super.key, required this.imagePath});

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  CroppedFile? croppedFile;
  File? originaFile;

  void initState() {
    super.initState();
  }

  Future<void> cropImage() async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: false),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedImage != null)
      setState(() {
        croppedFile = croppedImage;
      });
  }

  Widget getMenu() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      FloatingActionButton(
          onPressed: () {
            print("Clear");
          },
          backgroundColor: Colors.amber,
          tooltip: 'Clear',
          child: const Icon(Icons.clear)),
      FloatingActionButton(
          onPressed: () async {
            await cropImage();
            print("Cropped");
          },
          backgroundColor: Colors.amberAccent,
          tooltip: 'Crop',
          child: const Icon(Icons.crop))
    ]);
  }

  Widget getImage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final path = widget.imagePath;

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(children: [getImage(), getMenu()]));
  }
}
