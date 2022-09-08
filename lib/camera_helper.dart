// // Failed Attempt to Implement Controller/Helper to Manage Camera
// // can get back to in the future after basic page is working

// import "package:camera/camera.dart";

// //Camera functionality implemented in camera_screen for now.

// class CameraHelper {
//   late List<CameraDescription> _cameras;
//   late CameraController _controller;

//   static final CameraHelper _instance = CameraHelper._internal();

//   factory CameraHelper() {
//     return _instance;
//   }

//   CameraHelper._internal() {
//     print("CH Internal");
//     availableCameras().then((value) {
//       print(_cameras);
//       _cameras = value;
//     });
//     _controller = CameraController(_cameras[0], ResolutionPreset.max);
//   }

//   void initializeCamera() {
//     _controller.initialize().catchError((Object e) {
//       if (e is CameraException) {
//         print("Camera Error");
//         // Implement handling Camera Error
//         }
//       });
//   }

//   CameraPreview getCameraPreview() {
//     print("Camera Preview");
//     if (!_controller.value.isInitialized) {
//       initializeCamera();
//     }
//     return CameraPreview(_controller);
//   }
// }