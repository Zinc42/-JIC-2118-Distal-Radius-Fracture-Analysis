import 'package:flutter_sms/flutter_sms.dart';
import 'image_handler.dart';

//Class for creating/building text messages for app
class TextMsg {

  static void buildTextMsg() {
    ImageHandler imageHandler = ImageHandler();
    String message = "Radial Height: \n ${imageHandler.getRadialHeight()} \n Radial Inclination: \n ${imageHandler.getRadialInclination()}";

    //First param is the message being sent, second param is the list of recipents for the text
    //Currently null so user can just put in a contact they have saved to their phone
    _sendSMS(message, [""]);
  }

  static void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future<bool> _canSendSMS() async {
    bool _result = await canSendSMS();
    print(_result);
    return _result;
  }
}
