import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "screen_button.dart";

class CameraRollScreen extends StatefulWidget {
  const CameraRollScreen({Key? key}) : super(key: key);

  static const String id = "camera_roll_screen";

  @override
  State<CameraRollScreen> createState() => _CameraRollScreenState();
}

class _CameraRollScreenState extends State<CameraRollScreen> {
  @override
  File? image;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Camera Roll Image')),
        body: SafeArea(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: image != null ? Image.file(image!) : Text("No image Selected")),
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
                          //pickImage();
                        }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: ScreenButton(
                        buttonText: "Confirm", pressFunction: () {}),
                  ),
                ],
              )

              //
            ],
          )),
        ));
  }
}
