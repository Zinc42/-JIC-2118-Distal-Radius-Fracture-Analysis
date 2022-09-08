import 'package:flutter/material.dart';
import 'screen_button.dart';
import "package:camera/camera.dart";
import "camera_screen.dart";

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "image_upload_screen";

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      margin: EdgeInsets.symmetric(vertical: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(alignment: Alignment.center, children: [
            Positioned(left: 10, child: BackButton()),
            Align(
                child: Text(
              "Choose Analysis Type",
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            )),
            SizedBox(height: 80)
          ]),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ScreenButton(
                    buttonText: "From Camera",
                    pressFunction: () {
                      print("Camera");
                      toCameraScreen();
                      //Code to navigate to next screen goes here
                      //might look like navigator.push(context, static id of next screen when its made
                    },
                  ),
                  ScreenButton(
                    buttonText: "From Camera Roll",
                    pressFunction: () {
                      print("Camera Roll");
                      //Code to navigate to next screen goes here
                      //might look like navigator.push(context, static id of next screen when its made
                    },
                  ),
                  ScreenButton(
                    buttonText: "From Files",
                    pressFunction: () {
                      print("Files");
                      //Code to navigate to next screen goes here
                      //might look like navigator.push(context, static id of next screen when its made
                    },
                  ),
                  ScreenButton(
                    buttonText: "From Google Drive",
                    pressFunction: () {
                      print("Google Drive");
                      //Code to navigate to next screen goes here
                      //might look like navigator.push(context, static id of next screen when its made
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // temp button function to set to display Camera Screen
  void toCameraScreen() async {
    try {
      await availableCameras().then((cameras) {
          Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => CameraScreen(cameras: cameras)
          )
        );
      });
    } on CameraException catch (e) {
      print(e);
    }
  }
}
