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
Still needed:
Still have to draw lines between squares on the screen
//TODO: Make the blue draggable also update coordinate info
  //TODO: Make the draggables actually update coordinate information in image handler rather than fake data
  //TODO: add offset so that point is in middle of draggable
   //TODO: Make a class that contains the callback functions that can be used for both buttons rather than having a bunch of diff callbacks
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
  late Drag_Button draggableOne;
  late Drag_Button draggableTwo;

  //Passed image from last screen
  late FileImage imageFile = FileImage(File((widget.passedImagePath)));

  //These X and Y coordinates are the middle of
  late Coordinate firstPointInImageResolution;
  //These X and Y coordinates are the middle of
  late Coordinate secondPointInImageResolution;

  //TODO Move some of theses variables to a diff/class file to make top of file more clean
  //primitive implementation of a camera resolution TO screen scalar
  late double cameraToScreenRatioX;
  late double cameraToScreenRatioY;

  //primitive implementation of a screen resolution TO camera resolution scalar
  late double screenToCameraRatioX;
  late double screenToCameraRatioY;

  //Width of the container that holds the image on screen. Using this to calculate the scalars
  late double imgContainerWidth;
  late double imgContainerHeight;

  //These are used to push the point for coordinate calculation from top left of draggable widget to the center
  late double widthOfDraggable;
  late double heightOfDraggable;

  //width and height of passed image
  //this is needed to make sure if the offset calculated is going to move the coordinate OUTSIDE
  //the image, then leave coordinate at edge.
  late int widthOfImage;
  late int heightOfImage;

  //Stores x and y coordinates of where Dragable was at start of pan
  double prevDragableOneLocationX = 0;
  double prevDragableOneLocationY = 0;

  double prevDragableTwoLocationX = 0;
  double prevDragableTwoLocationY = 0;

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
            draggableOne,
            draggableTwo
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

    //These values should be the same as the width and height of the widget in dragable.dart
    heightOfDraggable = imgContainerHeight * 0.027;
    widthOfDraggable = imgContainerWidth * 0.065;

    //This is a temporary line to create a point that would normally be held in image handler when we get there
    //This point is calculated to be in the middle of the image file in its native resolution
    //This is also used to determine where the dragable initially spawns. We use math to convert where the point is in
    //the native image resolution to figure out where the dragable should roughly be in screen resolution
    firstPointInImageResolution = Coordinate(x: img.width! / 2, y: img.height! / 2);
    secondPointInImageResolution = Coordinate(x: firstPointInImageResolution.x + 50, y: firstPointInImageResolution.y + 50);

    //This function call sets the scalars that allow us to go from the image file's resolution to the screen resolution and back
    setScreenRatios(img.width!, img.height!);

    draggableOne = Drag_Button(
        startDragFunction: firstDragableStartCallback,
        pressFunction: firstDragableUpdateCallback,
        endDragFunction: firstDragableEndDragCallback,
        leftPos: firstPointInImageResolution.x * cameraToScreenRatioX,
        topPos: firstPointInImageResolution.y * cameraToScreenRatioY,
        color: Colors.red);

    draggableTwo = Drag_Button(
        startDragFunction: secondDragableStartCallback,
        pressFunction: secondDragableUpdateCallback,
        endDragFunction: secondDragableEndDragCallback,
        leftPos: secondPointInImageResolution.x * cameraToScreenRatioX,
        topPos: secondPointInImageResolution.y * cameraToScreenRatioY,
        color: Colors.blue);

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
  void firstDragableStartCallback(dragStartDetails) {
    prevDragableOneLocationX = draggableOne.getLeft();
    prevDragableOneLocationY = draggableOne.getTop();
    print("Started Drag");
  }

  void firstDragableUpdateCallback(details) {
    if (draggableOne != null) {
      //values for where to redraw the draggable widget after set state
      // min(container X or y - widthX or Y of the draggable it self, max(0 x and y, draggablelocation)
      double newTop = min(imgContainerHeight - (heightOfDraggable),
          max(0, draggableOne.getTop() + details.delta.dy));
      double newLeft = min(imgContainerWidth - (widthOfDraggable),
          max(0, draggableOne.getLeft() + details.delta.dx));

      //update the draggable reference
      draggableOne = Drag_Button(
          startDragFunction: firstDragableStartCallback,
          pressFunction: firstDragableUpdateCallback,
          endDragFunction: firstDragableEndDragCallback,
          topPos: newTop,
          leftPos: newLeft,
          color: Colors.red);
    }

    setState(() {});
  }

/*
Here the offset is calculted and used to update the coordinates in the native image resolution by multiplying the offset by scalars we generated
 */
  void firstDragableEndDragCallback(DragEndDetails) {
    //Where the dragable is now - where it was when dragging started
    //Now also moves the point of the coordinate to the center of the draggable square rather than the top left
    double newXOffset = ((draggableOne.getLeft()) - (prevDragableOneLocationX));
    double newYOffset = ((draggableOne.getTop()) - (prevDragableOneLocationY));

    //print("$newXOffset $newYOffset");
    //calulates the change in coordinates in image file native resolution based on (dx,dy) * scalar

    firstPointInImageResolution.UpdateCordinate(
        Offset(newXOffset, newYOffset),
        screenToCameraRatioX,
        screenToCameraRatioY,
        widthOfImage,
        heightOfImage);
    //shows new coordinates in console
    print(
        "New first point in camera resolution: ${firstPointInImageResolution.x} ${firstPointInImageResolution.y}");
    //Set local offset varable back to 0 otherwise if u just click but dont drag, it will use same offset that was used in last
    //drag end despite not actually moving
  }

  //Will make code cleaner

  void secondDragableStartCallback(dragStartDetails) {
    prevDragableTwoLocationX = draggableTwo.getLeft();
    prevDragableTwoLocationY = draggableTwo.getTop();
    print("Started Drag");
  }

  void secondDragableUpdateCallback(details) {
    if (draggableTwo != null) {
      //values for where to redraw the draggable widget after set state
      double newTop = min(imgContainerHeight - (heightOfDraggable),
          max(0, draggableTwo.getTop() + details.delta.dy));
      double newLeft = min(imgContainerWidth - (widthOfDraggable),
          max(0, draggableTwo.getLeft() + details.delta.dx));

      //update the draggable reference
      draggableTwo = Drag_Button(
          startDragFunction: secondDragableStartCallback,
          pressFunction: secondDragableUpdateCallback,
          endDragFunction: secondDragableEndDragCallback,
          topPos: newTop,
          leftPos: newLeft,
          color: Colors.blue);
    }

    setState(() {});
  }

  void secondDragableEndDragCallback(DragEndDetails) {
    //Where the dragable is now - where it was when dragging started
    double newXOffset = (draggableTwo.getLeft() - prevDragableTwoLocationX);
    double newYOffset = (draggableTwo.getTop() - prevDragableTwoLocationY);

    //print("$newXOffset $newYOffset");
    //calulates the change in coordinates in image file native resolution based on (dx,dy) * scalar

        secondPointInImageResolution.UpdateCordinate(
        Offset(newXOffset, newYOffset),
        screenToCameraRatioX,
        screenToCameraRatioY,
        widthOfImage,
        heightOfImage);


    //shows new coordinates in console
    print(
        "New second point in camera resolution: ${secondPointInImageResolution.x} ${secondPointInImageResolution.y}");
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

    //width and height of container from result_edit_screen.dart
    state.imgContainerWidth = screenWidth - 20;
    state.imgContainerHeight = screenHeight - 220;

    /*
        state.imgContainerWidth = (screenWidth * 0.9);
    state.imgContainerHeight = (screenHeight * 0.8);
    --------------------------------------------
          height: state.getScreenHeight() - 220,
      width: state.getScreenWidth() - 20,
     */

    return (Center(
      //-------------STEP 1------------------------------------------------------------:
      // makes an image pixels widget. comes from package.
      // we use this to get width and height of image to use for math
      //there is probably a better way to do this
      child: ImagePixels(
          imageProvider: state.imageFile,
          defaultColor: Colors.black,
          //calls imagePixelBuilder Method(step 2 scroll up)
          builder: state.imagePixelsBuilder),
    ));
  }
}
