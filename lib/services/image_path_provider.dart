import 'package:image_picker/image_picker.dart';

abstract class ImagePathProvider {
  Future<XFile?> getFilePath();
}

class ImagePickerPathProvider implements ImagePathProvider {
  @override
  Future<XFile?> getFilePath() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
