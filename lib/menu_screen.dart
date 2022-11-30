import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';

import "screen_button.dart";
import "image_upload_screen.dart";
import "loading_screen.dart";
import "welcome_screen.dart";
import "results_screen.dart";

import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as Path;

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
      return const AssetImage("lib/images/image_placeholder.png");
    } else {
      return FileImage(File(imageHandler.frontImagePath!));
    }
  }

  ImageProvider getSideImageDisplay() {
    if (imageHandler.sideImagePath == null) {
      return const AssetImage("lib/images/image_placeholder.png");
    } else {
      return FileImage(File(imageHandler.sideImagePath!));
    }
  }

  //upload front function
  uploadFront(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://distalradiusinspectionapi.com/predict-ap");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var tempString = response.body;
    tempString = tempString.substring(11);
    tempString=tempString.replaceAll("[","");
    tempString=tempString.replaceAll("]","");
    tempString=tempString.replaceAll("{","");
    tempString=tempString.replaceAll("}","");
    tempString=tempString.replaceAll(" ","");
    tempString=tempString.replaceAll("\"","");


    print(tempString);

    List<String> result = tempString.split(',');

    print(result);

    imageHandler.setRadialStyloidFront(double.parse(result[9]),double.parse(result[10]));
    imageHandler.setMinArticularSurface((double.parse(result[0])+double.parse(result[3]))/2, (double.parse(result[1])+double.parse(result[4]))/2);
  }

  //upload front function
  uploadLateral(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://distalradiusinspectionapi.com/predict-laterals");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var tempString = response.body;
    tempString = tempString.substring(11);
    tempString=tempString.replaceAll("[","");
    tempString=tempString.replaceAll("]","");
    tempString=tempString.replaceAll("{","");
    tempString=tempString.replaceAll("}","");
    tempString=tempString.replaceAll(" ","");
    tempString=tempString.replaceAll("\"","");


    print(tempString);

    List<String> result = tempString.split(',');

    print(result);

    imageHandler.setlateralUpper(double.parse(result[0]),double.parse(result[1]));
    imageHandler.setMinArticularSurface(double.parse(result[3]),double.parse(result[4]));

  }
  



  void runAnalysis() async {
    if (!imageHandler.isMissingImages()) {
      // run analysis only if both images have been uploaded
      print("Run Analysis");
      // code to run analysis
      print(imageHandler.getImageDisplayHeight());
      print(imageHandler.getImageDisplayWidth());
      await setImageRatio();
      print("outside if");

      // run model here

      // get images from ImageHandler

      // file PATHS stored as string:
      //  imageHandler.frontImagePath
      //  imageHandler.sideImagepath

      // loading screen if needed (refer to Results Screen)

      // make sure to use await for any asunc function calls
      if (imageHandler.frontImagePath!= null){
        await uploadFront(File(imageHandler.frontImagePath));
      }

      if (imageHandler.sideImagePath!= null){
        await uploadLateral(File(imageHandler.sideImagePath));
      }



      // call image handler to set point values after model is run
      // ex: imageHandler.LateralUpperX = value or there are setter functions in Image Handler

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResultsScreen()));
    } else {
      _showNoImageAlert();
    }
  }

  Future<void> setImageRatio() async {
    print("setImageRatio");
    if (!imageHandler.isSetImageToScreenRatio) {
      print("inside if");
      File imageFront = File(imageHandler.frontImagePath!);
      var decodedImageFront =
          await decodeImageFromList(imageFront.readAsBytesSync());
      imageHandler.setFrontImageScreenRatio(decodedImageFront.width.toDouble());

      File imageLateral = File(imageHandler.sideImagePath!);
      var decodedImageLateral =
          await decodeImageFromList(imageLateral.readAsBytesSync());
      imageHandler
          .setLateralImageScreenRatio(decodedImageLateral.width.toDouble());

      print(imageHandler.imageToScreenRatioFront);
      print(imageHandler.imageToScreenRatioLateral);

      imageHandler.isSetImageToScreenRatio = true;
    }
  }

  void toImageUploadScreen(bool isFront) {
    imageHandler.isFrontImage = isFront;
    Navigator.pushNamed(context, ImageUploadScreen.id)
        .then((value) => setState(() {}));
  }

  Future<void> _showNoImageAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
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
              ]);
        });
  }
}

// View class that purely builds the UI elements
class _MenuScreenView extends StatelessWidget {
  const _MenuScreenView({super.key, required this.state});

  final _MenuScreenState state;

  @override
  Widget build(BuildContext context) {
    final MenuScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as MenuScreenArguments;

    return Scaffold(
        body: Container(
      margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(alignment: Alignment.center, children: [
            const Positioned(left: 10, child: BackButton()),
            Align(
              child: Text(
                args.analysisType,
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          const SizedBox(height: 40),
          ScreenButton(
            buttonText: "Import Frontal View",
            pressFunction: () => state.toImageUploadScreen(true),
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
            pressFunction: () => state.toImageUploadScreen(false),
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
    ));
  }
}
