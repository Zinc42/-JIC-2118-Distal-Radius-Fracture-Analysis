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
  @override
  String imagePath = "lib/images/image_placeholder.png";

  Future pickImage() async {
    try {
      final imagePicked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicked == null) return;
      final temporaryImageFile = File(imagePicked.path);
      setState(() {
        this.imagePath = temporaryImageFile.path;
      });
    } on PlatformException catch (e) {
      //To do: Handle exception when user does not allow permission to camera roll
      print("Failed to pick image: $e");
    }
  }

  void moveToEditScreen() {
    if (imagePath != "lib/images/image_placeholder.png") {
      print(imagePath);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageEditScreen(imagePath: imagePath)));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Camera Roll Image')),
        body: SafeArea(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: imagePath != "lib/images/image_placeholder.png" ? Image(image: FileImage(File(imagePath))) : Image(width: 200, height: 200,
                  image: AssetImage("lib/images/image_placeholder.png"),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ScreenButton(
                        buttonText: "Select an Image",
                        pressFunction: () {
                          pickImage();
                        }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: ScreenButton(
                        buttonText: "Confirm",
                        pressFunction: () {
                          moveToEditScreen();
                        }),
                  ),
                ],
              )

              //
            ],
          )),
        ));
  }
}
