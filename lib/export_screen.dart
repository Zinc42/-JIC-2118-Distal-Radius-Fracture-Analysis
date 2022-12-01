import 'package:flutter/material.dart';
import 'package:distal_radius/screenshot_handler.dart';
import 'package:distal_radius/welcome_screen.dart';
import 'screen_button.dart';
import "text_and_email_export.dart";
import "image_handler.dart";

import 'package:permission_handler/permission_handler.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "export_screen";

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  ScreenshotHandler screenshotHandler = ScreenshotHandler();
  ImageHandler imageHandler = ImageHandler();
  @override
  Widget build(BuildContext context) => _ExportScreenView(state: this);

  void toTextMessageScreen() {
    // print("Send through text message");
    ExportFilesBuilder.buildExportFiles();
  }

  void toEmailScreen() {
    // print("Send through email");
  }

  void returnToHome() {
    imageHandler.reset();
    Navigator.of(context).popUntil(ModalRoute.withName(WelcomeScreen.id));
  }

  void toSaveCameraRollScreen() async {
    await getCameraPerms();

    bool succeeded = await screenshotHandler.saveAllFilesToCameraRoll();
    await showCameraResults(succeeded);
  }

  Future<void> showCameraResults(bool succeeded) async {
    Text titleText =
        succeeded ? const Text("Save Succeeded") : const Text("Save Failed");
    Text childText = succeeded
        ? const Text("All photos were saved.")
        : const Text("There was an error with saving.");

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: titleText,
              content: SingleChildScrollView(
                child: childText,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done"),
                ),
                TextButton(
                  onPressed: () {
                    returnToHome();
                  },
                  child: const Text("To Home"),
                )
              ]);
        });
  }

  Future<void> getCameraPerms() async {
    PermissionStatus cameraPermStatus = await Permission.camera.request();
    if (!cameraPermStatus.isGranted) {
      showCameraPermsAlert();
    }
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

class _ExportScreenView extends StatelessWidget {
  const _ExportScreenView({super.key, required this.state});

  final _ExportScreenState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
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
                  "Choose Export Method",
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
                    buttonText: "Save to Camera Roll",
                    pressFunction: state.toSaveCameraRollScreen,
                  ),
                  ScreenButton(
                      buttonText: "Send through Text or Email",
                      pressFunction: state.toTextMessageScreen),
                  /*
                  ScreenButton(
                      buttonText: "Send Through Email",
                      pressFunction: state.toEmailScreen),
                   */
                ],
              ),
            ),
          ]),
    )));
  }
}
