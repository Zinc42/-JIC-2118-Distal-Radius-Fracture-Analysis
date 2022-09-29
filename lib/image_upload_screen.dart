import 'package:flutter/material.dart';
import 'screen_button.dart';
import "package:camera/camera.dart";
import "camera_screen.dart";

import 'package:permission_handler/permission_handler.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "image_upload_screen";

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  @override
  Widget build(BuildContext context) => _ImageUploadScreenView(state: this);

  // button function to set to display Camera Screen
  void toCameraScreen() async {
    await getCameraPerms().then((permStatus) async {
      if (permStatus.isGranted) {
        await availableCameras().then((cameras) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(cameras: cameras)));
        });
      }
    });
  }

  void toCameraRollScreen() {
    print("Camera Roll");
    //Code to navigate to next screen goes here
    //might look like navigator.push(context, static id of next screen when its made
  }

  Future<PermissionStatus> getCameraPerms() async {
    PermissionStatus cameraPermStatus = await Permission.camera.request();
    if (!cameraPermStatus.isGranted) {
      showCameraPermsAlert();
    }

    return cameraPermStatus;
  }

  Future<void> showCameraPermsAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Camera Access Denied"),
              content: const SingleChildScrollView(
                child: Text("Enable camera to continue."),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: const Text("Settings"),
                ),
              ]);
        });
  }
}

class _ImageUploadScreenView extends StatelessWidget {
  const _ImageUploadScreenView({super.key, required this.state});

  final _ImageUploadScreenState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(vertical: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: const [
              Positioned(left: 10, child: BackButton()),
              Align(
                  child: Text(
                "Choose Analysis Type",
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              )),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ScreenButton(
                  buttonText: "From Camera",
                  pressFunction: state.toCameraScreen,
                ),
                ScreenButton(
                  buttonText: "From Camera Roll",
                  pressFunction: state.toCameraRollScreen
                ),
                ScreenButton(
                  buttonText: "From Files",
                  pressFunction: () {
                    print("Files");
                    // Implementation TBD
                  },
                ),
                ScreenButton(
                  buttonText: "From Google Drive",
                  pressFunction: () {
                    print("Google Drive");
                    // Implementation TBD
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
