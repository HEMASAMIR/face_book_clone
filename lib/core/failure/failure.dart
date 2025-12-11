import 'dart:io';

class Failure {
  final String message;
  Failure(this.message);
}

class UploadSuccess {
  const UploadSuccess();
}

// image_success.dart
class ImagePickedSuccess {
  final File file;
  ImagePickedSuccess(this.file);
}
