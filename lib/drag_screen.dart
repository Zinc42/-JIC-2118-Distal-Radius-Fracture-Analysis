import 'package:flutter/material.dart';
import 'dart:io';
import "dragable.dart";
import 'dart:math';
import 'package:image_pixels/image_pixels.dart';
import "coordinate.dart";
/*
How this scruffed ass proof of concept even works
start from the bottom build function at step 1
-----------------------------------------------------
ISSUES:
Still have to draw lines between squares on the screen

If u drag the dragable outside the container with the image, but NOT OFF THE PHONE, the values for offset are still actually being changed.
possible fixes:
1. make it so container that image is in touches the edge of the phone screen
2. Some other bs

*/

class DragScreen extends StatefulWidget {
  final String passedImagePath;

  const DragScreen({super.key, required this.passedImagePath});

  //const DragScreen({Key? key}) : super(key: key);
  static const String id = "drag_screen";

  @override
  State<DragScreen> createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {
  @override
  Widget build(BuildContext context) => _DragScreenView(state: this);

  //REFERENCE TO DRAGGABLE WIDGET
  late Drag_Button drag;

  //Passed image from last screen
  late FileImage imageFile = FileImage(File((widget.passedImagePath)));

  //These X and Y coordinates are the middle of
  late Coordinate pointInImageResolution;

  //primitive implementation of a camera resolution TO screen scalar
  late double cameraToScreenRatioX;
  late double cameraToScreenRatioY;

  //primitive implementation of a screen resolution TO camera resolution scalar
  late double screenToCameraRatioX;
  late double screenToCameraRatioY;

  //Width of the container that holds the image on screen. Using this to calculate the scalars
  late double imgContainerWidth;
  late double imgContainerHeight;

  //width and height of passed image
  //this is needed to make sure if the offset calculated is going to move the coordinate OUTSIDE
  //the image, then leave coordinate at edge.
  late int widthOfImage;
  late int heightOfImage;

  //Stores x and y coordinates of where Dragable was at start of pan
  double prevDragableLocationX = 0;
  double prevDragableLocationY = 0;

  bool initialized = false;



  /*
  ------------------------STEP 2-----------------------------------------------------------------------------------------------------
  ImgDetails img parameter just contains info about the image provided to the builder
    If none of the varables used for the math have been set, the method will first called an initialze function
    Then it returns the Stack to be rendered on the screen. This stack contains the image(in screen resolution NOT the resolution
    the file is actually in natively) and custom dragable widget
    See dragable.dart for how it works
    when the dragable is clicked/dragged the callback function is called. see step 3 down
   */
  Widget imagePixelsBuilder(BuildContext context, ImgDetails img) {
    if (img.hasImage && !initialized) {
      dataInitializer(context, img);
    }

    if (initialized) {
      return Container(
        color: Colors.black,
        width: imgContainerWidth,
        height: imgContainerHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(widget.passedImagePath)),
            //the draggable button
            drag
          ],
        ),
      );
    }
    //Return function needed here so method always returns something. (Goes off if initializer wasnt done)
    return CircularProgressIndicator();
  }

  //The function that initializes data for the screen
  void dataInitializer(BuildContext context, ImgDetails img) {
    print("Width of image: ${img.width} Height of img: ${img.height}");
    widthOfImage = img.width!;
    heightOfImage = img.height!;
    //This is a temporary line to create a point that would normally be held in image handler when we get there
    //This point is calculated to be in the middle of the image file in its native resolution
    //This is also used to determine where the dragable initially spawns. We use math to convert where the point is in
    //the native image resolution to figure out where the dragable should roughly be in screen resolution
    pointInImageResolution = Coordinate(x: img.width! / 2, y: img.height! / 2);

    //This function call sets the scalars that allow us to go from the image file's resolution to the screen resolution and back
    setScreenRatios(img.width!, img.height!);

    drag = Drag_Button(
      startDragFunction: DragableStartCallback,
      pressFunction: DragableUpdateCallback,
      endDragFunction: DragableEndDragCallback,
      leftPos: pointInImageResolution.x * cameraToScreenRatioX,
      topPos: pointInImageResolution.y * cameraToScreenRatioY,
    );

    initialized = true;
  }

  //Calculates scalars to use when updating image coordinates
  void setScreenRatios(int imgWidth, int imgHeight) {
    cameraToScreenRatioX = imgContainerWidth / imgWidth;
    cameraToScreenRatioY = imgContainerHeight / imgHeight;

    screenToCameraRatioX = imgWidth / imgContainerWidth;
    screenToCameraRatioY = imgHeight / imgContainerHeight;
  }

//-------STEP 3 ----------------------------------------------------------------------------------


  /*
  When the user starts dragging start callback is called. Stores location of dragable in stack
  on update callback just updates the location of the dragable on screen
  On end drag callback takes the difference between where dragable started and where it ended after the pan and uses that offset in the math with scalars
   */
  void DragableStartCallback(dragStartDetails) {
    prevDragableLocationX = drag.getLeft();
    prevDragableLocationY = drag.getTop();
    print("Started Drag");
  }

  void DragableUpdateCallback(details) {
    if (drag != null) {
      //values for where to redraw the draggable widget after set state
      double newTop = min(imgContainerHeight - (imgContainerHeight * 0.035), max(0, drag.getTop() + details.delta.dy));
      double newLeft = min(imgContainerWidth - (imgContainerWidth * 0.08) , max(0, drag.getLeft() + details.delta.dx));

      //update the draggable reference
      drag = Drag_Button(
        startDragFunction: DragableStartCallback,
          pressFunction: DragableUpdateCallback,
          endDragFunction: DragableEndDragCallback,
          topPos: newTop,
          leftPos: newLeft);
    }

    setState(() {});
  }

/*
Here the offset is calculted and used to update the coordinates in the native image resolution by multiplying the offset by scalars we generated
 */
  void DragableEndDragCallback(DragEndDetails) {
    //Where the dragable is now - where it was when dragging started
    double newXOffset =  (drag.getLeft() - prevDragableLocationX);
    double newYOffset =  (drag.getTop() - prevDragableLocationY);

    //print("$newXOffset $newYOffset");
    //calulates the change in coordinates in image file native resolution based on (dx,dy) * scalar
    pointInImageResolution.UpdateCordinate(
        Offset(newXOffset,newYOffset), screenToCameraRatioX, screenToCameraRatioY, widthOfImage, heightOfImage);
    //shows new coordinates in console
    print(
        "New point in camera resolution: ${pointInImageResolution.x} ${pointInImageResolution.y}");
    //Set local offset varable back to 0 otherwise if u just click but dont drag, it will use same offset that was used in last
    //drag end despite not actually moving

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
        //-------------STEP 1------------------------------------------------------------:
        // makes an image pixels widget. comes from package.
        // we use this to get width and height of image to use for math
        //there is probably a better way to do this
        child: ImagePixels(
            imageProvider: state.imageFile,
            defaultColor: Colors.black,
            //calls imagePixelBuilder Method(step 2 scroll up)
            builder: state.imagePixelsBuilder),
      ),
    ));
  }
}
