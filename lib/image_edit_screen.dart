import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';

class ImageEditScreen extends StatefulWidget {
  final String imagePath;

  const ImageEditScreen({super.key, required this.imagePath});

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  final controller = CropController(aspectRatio: 9.0 / 16.0);
  double rotation = 0;
  BoxShape shape = BoxShape.rectangle;

  RawImage? croppedImage;
  File? originaFile;

  void initState() {
    super.initState();
  }

  Future<void> cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Crop Result'),
            centerTitle: true,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    print("here");
                  },
                ),
              ),
            ],
          ),
          body: Center(
            child: RawImage(
              image: cropped,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void cancelImage() {
    Navigator.of(context).popUntil(ModalRoute.withName("image_upload_screen"));
  }

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Cancel Upload'),
          onPressed: cancelImage,
        ),
        ElevatedButton(
          child: const Text('Confirm Image'),
          onPressed: cropImage,
        )
      ],
    );
  }

  Widget getMenu() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {
            controller.rotation = 0;
            controller.scale = 1;
            controller.offset = Offset.zero;
            setState(() {
              rotation = 0;
            });
          },
        ),
        Expanded(
          child: SliderTheme(
            data: ThemeData(primarySwatch: Colors.blue).sliderTheme,
            child: Slider(
              divisions: 360,
              value: rotation,
              min: -180,
              max: 180,
              label: '$rotation°',
              onChanged: (n) {
                setState(() {
                  rotation = n.roundToDouble();
                  controller.rotation = rotation;
                });
              },
            ),
          ),
        ),
        PopupMenuButton<double>(
          icon: const Icon(Icons.aspect_ratio),
          itemBuilder: (context) => [
            const PopupMenuItem(
              child: Text("Original"),
              value: 1000 / 667.0,
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              child: Text("16:9"),
              value: 16.0 / 9.0,
            ),
            const PopupMenuItem(
              child: Text("4:3"),
              value: 4.0 / 3.0,
            ),
            const PopupMenuItem(
              child: Text("1:1"),
              value: 1,
            ),
            const PopupMenuItem(
              child: Text("3:4"),
              value: 3.0 / 4.0,
            ),
            const PopupMenuItem(
              child: Text("9:16"),
              value: 9.0 / 16.0,
            ),
          ],
          tooltip: 'Aspect Ratio',
          onSelected: (x) {
            controller.aspectRatio = x;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget getImage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final path = widget.imagePath;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 0.9 * screenWidth,
        maxHeight: 0.7 * screenHeight,
      ),
      child: Crop(
        onChanged: (decomposition) {
          if (rotation != decomposition.rotation) {
            setState(() {
              rotation = ((decomposition.rotation + 180) % 360) - 180;
            });
          }
        },
        controller: controller,
        shape: shape,
        child: Image.asset(path, fit: BoxFit.cover),
        foreground: IgnorePointer(
          ignoring: false,
          child: Container(
            alignment: Alignment.bottomRight,
          ),
        ),
        helper: shape == BoxShape.rectangle
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
              )
            : null,
      ),
    );
  }

  Widget getHeader() {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Positioned(left: 10, child: BackButton()),
        Align(
            child: Text(
          "Align Image",
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 35.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getHeader(),
                  getImage(),
                  getMenu(),
                  getBottomButtons()
                ])));
  }
}
