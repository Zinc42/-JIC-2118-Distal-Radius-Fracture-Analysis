import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "screen_button.dart";
import "image_edit_screen.dart";

class CameraRollScreen extends StatefulWidget {
  const CameraRollScreen({Key? key}) : super(key: key);

  static const String id = "camera_roll_screen";

  @override
  State<CameraRollScreen> createState() => _CameraRollScreenState();
}

class _CameraRollScreenState extends State<CameraRollScreen> {

  String imagePath = "lib/images/image_placeholder.png";

  Future pickImage() async {
    try {
      final imagePicked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicked == null) return;
      final temporaryImageFile = File(imagePicked.path);
      setState(() {
        imagePath = temporaryImageFile.path;
      });
    } on PlatformException catch (e) {
      //To do: Handle exception when user does not allow permission to camera roll
      debugPrint("Failed to pick image: $e");
    }
  }

  void moveToEditScreen() {
    if (imagePath != "lib/images/image_placeholder.png") {
      // print(imagePath);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageEditScreen(imagePath: imagePath)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: const [
                Positioned(left: 10, child: BackButton()),
                Align(
                  child: Text(
                    "From Camera Roll",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  )
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: imagePath != "lib/images/image_placeholder.png" ? 
                Image(width: screenWidth - 40, height: screenHeight - 250, image: FileImage(File(imagePath))) : 
                Image(width: screenWidth - 40, height: screenHeight - 250, image: const AssetImage("lib/images/image_placeholder.png")),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ScreenButton(
                    width: (screenWidth - 60) / 2,
                    buttonText: "Select an Image",
                    pressFunction: () {
                      pickImage();
                    }),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: ScreenButton(
                    width: (screenWidth - 60) / 2,
                    buttonText: "Confirm",
                    pressFunction: () {
                      moveToEditScreen();
                    }),
                ),

              ],
            )
          ],
        )
      ),
    );
  }
}
