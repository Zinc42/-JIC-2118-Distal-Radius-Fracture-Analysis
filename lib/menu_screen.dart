import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';

import "screen_button.dart";
import "image_upload_screen.dart";
import "loading_screen.dart";
import "welcome_screen.dart";

import 'dart:io';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  static const String id = "menu_screen";

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

// argument class to encapsulate arguments that can be passed to the screen
class MenuScreenArguments {
  MenuScreenArguments({required this.analysisType});

  final String analysisType;
}

// State class that handles logic in the screen
// contains all functions relevant to business logic
class _MenuScreenState extends State<MenuScreen> {

  ImageHandler imageHandler = ImageHandler();

  @override
  Widget build(BuildContext context) => _MenuScreenView(state: this);

  ImageProvider getFrontImageDisplay() {
    if (imageHandler.frontImagePath == null) {
      return AssetImage("lib/images/image_placeholder.png");
    } else {
      return FileImage(File(imageHandler.frontImagePath!));
    }
  }

  ImageProvider getSideImageDisplay() {
    if (imageHandler.sideImagePath == null) {
      return AssetImage("lib/images/image_placeholder.png");
    } else {
      return FileImage(File(imageHandler.frontImagePath!));
    }
  }

  void runAnalysis() {
    Navigator.pushNamed(
      context,
      LoadingScreen.id);
    if (!imageHandler.isMissingImages()) {
      // run analysis only if both images have been uploaded
      print("Run Analysis");
      // code to run analysis 
    } else {
      _showNoImageAlert();
    }
  }

  Future<void> _showNoImageAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: const Text("Missing Image"),
          content: const SingleChildScrollView(
            child: Text("Required Images are Missing."),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]
        );
      }
    );
  }
}

// View class that purely builds the UI elements
class _MenuScreenView extends StatelessWidget {
  const _MenuScreenView({super.key, required this.state});

  final _MenuScreenState state;

  @override
  Widget build(BuildContext context) {

    final MenuScreenArguments args = ModalRoute.of(context)!.settings.arguments as MenuScreenArguments;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center, 
              children: [
                const Positioned(left: 10, child: BackButton()),
                Align(
                  child: Text(
                    args.analysisType,
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            ),
            const SizedBox(height: 40),
            ScreenButton(
              buttonText: "Import Frontal View",
              pressFunction: () {
                Navigator.pushNamed(
                  context,
                  ImageUploadScreen.id);
              },
            ),
            const SizedBox(height: 20),
            Image(
              height: 200,
              width: 200,
              image: state.getFrontImageDisplay(),
            ),
            const SizedBox(
              height: 30,
            ),
            ScreenButton(
              buttonText: "Import Side View",
              pressFunction: () {
                Navigator.pushNamed(
                  context,
                  ImageUploadScreen.id);
              },
            ),
            const SizedBox(height: 20),
            Image(
              height: 200,
              width: 200,
              image: state.getSideImageDisplay(),
            ),
            const SizedBox(
              height: 50,
            ),
            ScreenButton(
              buttonText: "Run Analysis",
              pressFunction: state.runAnalysis,
            ),
            
          ],
        ),
      ) 
    );
  }
}
