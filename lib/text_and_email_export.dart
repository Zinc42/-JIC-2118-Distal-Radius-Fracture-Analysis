
import "screenshot_handler.dart";
import 'package:share_plus/share_plus.dart';

//Class for creating/building text messages for app
class ExportFilesBuilder {

  static void buildExportFiles() {
  //Get results images from screen shot handler
    ScreenshotHandler screenshotHandler = ScreenshotHandler();
    String frontResultsImagePath = screenshotHandler.frontResultsPath!;
    String sideResultsPath = screenshotHandler.sideResultsPath!;
    String resultsTextPath = screenshotHandler.textResultsPath!;


    //Cast image paths to XFiles and pass it in as a list
    Share.shareXFiles([XFile(frontResultsImagePath), XFile(sideResultsPath), XFile(resultsTextPath)]);
    //_sendSMS(message, [""]);
  }


}