import 'package:flutter/material.dart';
import "welcome_screen.dart";
import "camera_screen.dart";
import "image_upload_screen.dart";

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
        CameraScreen.id: (context) => CameraScreen(),
        ImageUploadScreen.id: (context) => const ImageUploadScreen(),
      }
    );
  }
}
