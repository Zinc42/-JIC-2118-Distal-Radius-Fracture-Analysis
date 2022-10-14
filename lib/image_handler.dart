
// singleton Image Handler class
class ImageHandler {
  static final ImageHandler _instance = ImageHandler._internal();

  // stores paths to image files
  String? frontImagePath;
  String? sideImagePath;

  // boolean value indicating which image is currently
  // selected for upload
  bool isFrontImage = true;

  // a number tag to add at the end of file paths/names so that
  // new images can be saved (if user retakes an image)
  int fileID = 0;

  // length of the scale line(s) in cm (IRL)
  double? frontalLineLength;
  double? sideLineLength;
  // length of the scale line(s) in pixels
  double? frontalLineScreenLength;
  double? sideLineScreenLength;
 
  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  void setInputScale(double? lineLength, double? lineScreenLength, ) {
    if (isFrontImage) {
      frontalLineLength = lineLength;
      frontalLineScreenLength = lineScreenLength;
    } else {
      sideLineLength = lineLength;
      sideLineScreenLength = lineScreenLength;
    }
  }

  String getNewFileID() {
    String newFileID = fileID.toString();
    fileID++;
    return newFileID;
  }

  // basic getters/setters
  void setCurrImagepath(String newImagePath) {
    if (isFrontImage) {
      setFrontImagePath(newImagePath);
    } else {
      setSideImagePath(newImagePath);
    }
  }

  void setFrontImagePath(String newFrontImagePath) {
    frontImagePath = newFrontImagePath;
  }

  void setSideImagePath(String newSideImagePath) {
    sideImagePath = newSideImagePath;
  }

  bool isMissingImages() {
    return frontImagePath == null || sideImagePath == null;
  }

  bool getIsFrontImage() {
    return isFrontImage;
  }
  
}