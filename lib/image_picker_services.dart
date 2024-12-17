// image_picker_services.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Mobile image picker
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // Web image picker
  // static Future<Uint8List?> pickImageWeb() async {
  //   final pickedFile = await ImagePickerWeb.getImageAsBytes();
  //   return pickedFile;
  // }
}
