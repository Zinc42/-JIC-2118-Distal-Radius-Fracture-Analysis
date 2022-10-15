import 'package:flutter/material.dart';
import 'dart:io';
import "dragable.dart";
import 'dart:math';
import 'package:image_pixels/image_pixels.dart';
import "coordinate.dart";

class DragScreen extends StatefulWidget {
  final String passedImagePath;

  const DragScreen({super.key, required this.passedImagePath});

  //const DragScreen({Key? key}) : super(key: key);
  static const String id = "drag_screen";

  @override
  State<DragScreen> createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {
  late Drag_Button button;
  late FileImage imageFile;

  //These X and Y coordinates are the middle of
   late Coordinate pointInImageResolution;

  late double cameraToScreenRatioX;
  late double cameraToScreenRatioY;

  late double screenToCameraRatioX;
  late double screenToCameraRatioY;

  late double imgContainerWidth;
  late double imgContainerHeight;

  bool initialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageFile = FileImage(File((getImage())));
  }

  @override
  Widget build(BuildContext context) => _DragScreenView(state: this);

  String getImage() {
    return widget.passedImagePath;
  }

//TODO: make copy of a dragable callback to apply to other button
  void DragableUpdateCallback(details) {
    if (button != null) {
      double newTop =
           max(0, button.getTop() + details.delta.dy);
      double newLeft =
           max(0, button.getLeft() + details.delta.dx);
      button = Drag_Button(
          pressFunction: DragableUpdateCallback,
          topPos: newTop,
          leftPos: newLeft);

      print("dx: ${details.delta.dx.round()} dy: ${details.delta.dy.round()}");
      pointInImageResolution.UpdateCordinate(details.delta.dx.round(), details.delta.dy.round(), screenToCameraRatioX, screenToCameraRatioY);
      print("New point in camera resolution: ${pointInImageResolution.x} ${pointInImageResolution.y}");
    }
    setState(() {});
  }

  Widget imagePixelsBuilder(BuildContext context, ImgDetails img) {
    if (img.hasImage && !initialized) {
      print("Width of image: ${img.width} Height of img: ${img.height}");

      pointInImageResolution = Coordinate(x: img.width! / 2, y: img.height! / 2);

      setScreenRatios(img.width!, img.height!);
      button = Drag_Button(
        pressFunction: DragableUpdateCallback,
        leftPos: pointInImageResolution.x * cameraToScreenRatioX,
        topPos: pointInImageResolution.y * cameraToScreenRatioY,
      );
      initialized = true;
    }

    if (initialized) {
      return Container(
        color: Colors.black,
        width: imgContainerWidth,
        height: imgContainerHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [Image.file(File(getImage())), button],
        ),
      );
    }
    return CircularProgressIndicator();
  }

  void setScreenRatios(int imgWidth, int imgHeight) {
    cameraToScreenRatioX = imgContainerWidth / imgWidth;
    cameraToScreenRatioY = imgContainerHeight / imgHeight;

    screenToCameraRatioX = imgWidth / imgContainerWidth;
    screenToCameraRatioY = imgHeight / imgContainerHeight;
  }
}

class _DragScreenView extends StatelessWidget {
  const _DragScreenView({super.key, required this.state});

  final _DragScreenState state;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    state.imgContainerWidth = (screenWidth * 0.9);
    state.imgContainerHeight = (screenHeight * 0.8);

    return (Scaffold(
      appBar: AppBar(title: const Text('Image Taken')),
      body: Center(
        child: ImagePixels(
            imageProvider: state.imageFile,
            defaultColor: Colors.black,
            builder: state.imagePixelsBuilder),
      ),
    ));
  }
}
