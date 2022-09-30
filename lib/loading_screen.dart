import 'package:distal_radius/image_upload_screen.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import "camera_screen.dart";
import 'screen_button.dart';
import "menu_screen.dart";

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "loading_screen";

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                //back button
                  Stack(alignment: Alignment.center, children: const [
                    Positioned(left: 10, child: BackButton()),
                    Align(
                        child: Text(
                          "Loading Screen",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        )),
                  ]),

                  SizedBox(
                    //SPACEN BETWEEN LOGO AND TITLE TEXT
                    height: 10,
                  ),
                    Container(
                      child: Image(
                        image: AssetImage("lib/images/loading.gif"),
                        width: 400.0,
                        height: 400.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  //SPACE BETWEEN LOGO AND BUTTON SECTION OF SCREEN
                  height: 30.0,
                ),

              ],
            ),
          )
      )
    );
  }
}