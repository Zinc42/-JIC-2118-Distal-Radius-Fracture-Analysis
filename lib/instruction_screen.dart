import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import "camera_screen.dart";
import 'screen_button.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  //String to be used in navigator
  static const String id = "instructions_screen";

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  var descriptions = [
    "This is the first screen you will see when opening the app. "
        "There will be two buttons to choose from. The first one will start a pre-op analysis and take you to the next screen "
        "in the process. The second button will take you to the instructions if you need to refer back to them.",
    "The second step is to import the two images you will use. As you can see from the Import Screen, "
        "you must import the AP/PA and Lateral images by clicking on the corresponding button. You can also "
        "see each image after importing. Once both images are available, you can click the Run Analysis "
        "button to continue to the next step. \n\n"
        "Once you have clicked on one of the two import buttons, you will be taken to the Import Method screen. "
        "On this screen, there are 2 ways to import that we've implemented: \n"
        " \u2022 Camera Roll \n"
        " \u2022 Camera \n"
        "Once you click on each of the two buttons, you'll be taken to a corresponding page to import the image.",
    "This step comes right after importing an image but before we run the analysis. After you choose a picture "
        "from your camera roll or take the picture from the Camera Screen, you must edit the image to have an accurate analysis.\n\n"
        "First, you will go to the Image Alignment Screen. This screen lets you zoom, rotate, and move the image. Once you feel that "
        "the image looks aligned, you can click the Crop Image button to crop it.\n\n",
    "Second, the cropped image is used in the Alignment Confirm Screen. This screen lets you see the cropping result and make sure "
        "that it looks correct. If not, you can go back to the Image Alignment Screen and try again. This screen also has a red line on "
        "the image. There is a text box right below that asks for the length of that red line. This is because our analysis needs to have "
        "a scale to use in the calculations. After you put in a valid number, you can click the Confirm Image button to finish editing.\n\n"
        "This will take you back to the Image Upload Screen which you can then use to run your analysis.",
    "The third step is to view and edit the results. Once the app has calculated the results, it will take you to the Results Screen. "
        "This screen contains the two images you imported, and under them, there are 3 boxes that show values the app calculated.\n\n"
        "Each box has the calculated value on the left, and on the right, there is a range of what the value should be to be considered healthy. "
        "The left value also has a corresponding color based on how close it is to the range between red, yellow, and green. Green means the value is "
        "inside the range, yellow means it's close but not inside it, and red means that it's far away from the range.\n\n"
        "You can also click on each of the two images to see more info about the points. Once you've clicked on one, the Results X-ray Display Screen "
        "will pop up. This screen shows the image and the points found for that image. If you believe that these points are incorrect, "
        "you can click on the Edit Points button to go to a new screen and edit them.\n\n",
    "The Measurement Edit Screen allows you to edit these points by holding a point and dragging it somewhere else on the image. Once you've finished, "
        "you can click the Confirm Edit button to confirm your changes. Then you will return to the previous screen with the new points, and the "
        "Results Screen will also update its measurements when necessary.\n\n"
        "Once you've approved the results, you can export the results by clicking the Export Button.",
    "The fourth and last step is to export the results. The Export Screen has 2 buttons to either save to the camera roll or show a new pop-up "
        "that lets you send the info through email or text.\n\n"
        "If you click on the Save to Camera Roll button, the app will save 3 images to your device's camera roll: \n"
        "\u2022 Results Screen \n"
        "\u2022 Side Image \n"
        "\u2022 Front Image \n"
        "Once this is done, a pop-up will appear to indicate that saving was successful.\n"
        "If you click on the other button, a pop-up will appear with many options to export the images. You can click the email option, and "
        "a prompt will appear with the images already preloaded and will ask for the recipient's email. You can also click the text message option "
        "and another prompt will appear with the info preloaded and will ask for the recipient's phone number. \n\n"
        "Once you've finished exporting, you can exit the app, or go back to the results screen.",
    "This app allows you to take 2 pictures of an x-ray showing a frontal (AP/PA) view and a side (Lateral) view. With these pictures, the app will run an "
        "analysis on these images to find a few key points. These points are shown in the pictures above as an example.\n\n"
        "With these points, we can get some of the following measurements: \n"
        " \u2022 Volar Tilt \n"
        " \u2022 Radial Height \n"
        " \u2022 Radial Inclination \n\n"
        "Once the results have been found, you can export the values and the 2 pictures by sending an email/text message, or saving to camera roll. The next "
        "few pages will give instructions on each step in the process."
  ];

  PageViewModel welcomeInfo() {
    return PageViewModel(
        title: "\n1. Choose Analysis Type",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(border: Border.all(width: 0.5)),
                child: Image(
                  image: const AssetImage("lib/images/welcome.png"),
                  height: 400.0,
                )),
            Text("Welcome Screen",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Text(descriptions[0])
          ],
        ));
  }

  PageViewModel uploadInfo() {
    final screenWidth = MediaQuery.of(context).size.width;
    return PageViewModel(
        title: "\n2. Import Image",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/importScreen.png"),
                        height: 400.0,
                      )),
                  Text("Import Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(width: 5),
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/importMethod.png"),
                        height: 400.0,
                      )),
                  Text("Import Method Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ])
              ],
            ),
            const SizedBox(height: 25),
            Text(descriptions[1])
          ],
        ));
  }

  PageViewModel cameraInfo() {
    return PageViewModel(
        title: "\n2.5 Edit Image",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/cameraTake.png"),
                        height: 400.0,
                      )),
                  Text("Camera Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(width: 5),
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/alignImage.png"),
                        height: 400.0,
                      )),
                  Text("Image Alignment Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(height: 25),
            Text(descriptions[2]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.5)),
                  child: Image(
                    image: const AssetImage("lib/images/alignConfirm.png"),
                    height: 400.0,
                  )),
              Text("Alignment Confirm Screen",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 25),
            Text(descriptions[3])
          ],
        ));
  }

  PageViewModel resultsInfo() {
    return PageViewModel(
        title: "\n3. View and Edit Results",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/results.png"),
                        height: 400.0,
                      )),
                  Text("Results Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(width: 5),
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/resultPoints.png"),
                        height: 400.0,
                      )),
                  Text("Results X-Ray Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(height: 25),
            Text(descriptions[4]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.5)),
                  child: Image(
                    image: const AssetImage("lib/images/adjustPoints.png"),
                    height: 400.0,
                  )),
              Text("Measurement Edit Screen",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 25),
            Text(descriptions[5])
          ],
        ));
  }

  PageViewModel exportInfo() {
    return PageViewModel(
        title: "\n4. Export Results",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/exportScreen.png"),
                        height: 400.0,
                      )),
                  Text("Export Screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(width: 5),
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/exportPopup.png"),
                        height: 400.0,
                      )),
                  Text("Export Pop-up",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(height: 25),
            Text(descriptions[6])
          ],
        ));
  }

  PageViewModel introductionInfo() {
    return PageViewModel(
        title: "\nIntroduction",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/frontResults.png"),
                        width: 175.0,
                      )),
                  Text("AP/PA Results",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(width: 5),
                Column(children: [
                  Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Image(
                        image: const AssetImage("lib/images/sideResults.png"),
                        width: 175.0,
                      )),
                  Text("Lateral Results",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(height: 25.0),
            Text(descriptions[7])
          ],
        ));
  }

  void returnHome() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: [
          introductionInfo(),
          welcomeInfo(),
          uploadInfo(),
          cameraInfo(),
          resultsInfo(),
          exportInfo()
        ],
        showNextButton: true,
        next: const Text("Next"),
        skip: const Text("Exit"),
        showSkipButton: true,
        showDoneButton: true,
        done: const Text("Done"),
        onSkip: returnHome,
        onDone: returnHome);
  }
}
