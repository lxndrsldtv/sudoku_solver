import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

abstract class ImagePathProvider {
  Future<XFile?> getFilePath();
}

class ImagePickerPathProvider implements ImagePathProvider {
  final logger = Logger('ImagePickerPathProvider');

  @override
  Future<XFile?> getFilePath() async {
    logger.info('Picking image from gallery');
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
