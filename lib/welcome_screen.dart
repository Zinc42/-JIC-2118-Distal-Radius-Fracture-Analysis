import 'package:distal_radius/image_upload_screen.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import "camera_screen.dart";
import 'screen_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "welcome_screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Analysis of Distal Radius Fractures",
                  textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  //SPACEN BETWEEN LOGO AND TITLE TEXT
                  height: 10,
                ),
                Container(
                  child: Image(
                    image: AssetImage("lib/images/emory.jpg"),
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              //SPACE BETWEEN LOGO AND BUTTON SECTION OF SCREEN
              height: 30.0,
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Choose Analysis Type",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                    ScreenButton(
                      buttonText: "Pre-Operation Analysis",
                      pressFunction: () {
                        Navigator.pushNamed(
                            context,
                            ImageUploadScreen.id);
                      },
                    ),
                    ScreenButton(
                      buttonText: "Post-Operation Analysis",
                      pressFunction: () {
                        Navigator.pushNamed(
                            context,
                            ImageUploadScreen.id);
                      },
                    ),
                    ScreenButton(
                      buttonText: "Advanced Instructions",
                      pressFunction: () {
                        print("test");
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
    ),
      ));
  }
}
