import 'package:image_picker/image_picker.dart';

class ImagesList {
  static final ImagesList _instance = ImagesList._internal();
  factory ImagesList() => _instance;

  ImagesList._internal();

  List<XFile> imagespaths = [];

  void clearimages() {
    imagespaths.clear();
  }

  void updateImage(int index, XFile newImage) {
    if (index >= 0 && index < imagespaths.length) {
      imagespaths[index] = newImage;
    }
  }
}
