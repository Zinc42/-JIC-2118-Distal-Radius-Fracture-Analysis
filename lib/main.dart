import 'package:flutter/material.dart';
import "welcome_screen.dart";
import "camera_screen.dart";
import "image_upload_screen.dart";
import "camera_roll_screen.dart";
import "menu_screen.dart";
import "loading_screen.dart";

void main() {
  runApp(const DistalRadius());
}

class DistalRadius extends StatelessWidget {
  const DistalRadius({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      //routes to different screens
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        MenuScreen.id : (context) => const MenuScreen(),
        //CameraScreen.id: (context) => CameraScreen(),   // need to add support with passing arguments w/ named routes
        ImageUploadScreen.id: (context) => const ImageUploadScreen(),
        CameraRollScreen.id: (context) => const CameraRollScreen(),
        LoadingScreen.id: (context) => const LoadingScreen(),

      }
    );
  }
}
