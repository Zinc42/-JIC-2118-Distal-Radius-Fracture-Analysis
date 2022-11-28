import 'package:distal_radius/image_upload_screen.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import "camera_screen.dart";
import 'screen_button.dart';
import "menu_screen.dart";
import "instruction_screen.dart";

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
      margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
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
                      Navigator.pushNamed(context, MenuScreen.id,
                          arguments: MenuScreenArguments(
                              analysisType: "Pre-Operation Analysis"));
                    },
                  ),
                  ScreenButton(
                    buttonText: "Post-Operation Analysis",
                    pressFunction: () {
                      Navigator.pushNamed(context, MenuScreen.id,
                          arguments: MenuScreenArguments(
                              analysisType: "Post-Operation Analysis"));
                    },
                  ),
                  ScreenButton(
                    buttonText: "Advanced Instructions",
                    pressFunction: () {
                      print(InstructionScreen.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstructionScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
