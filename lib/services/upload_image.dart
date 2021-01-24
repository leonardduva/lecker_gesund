import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UploadImage {
  final picker = ImagePicker();
  String postId = Uuid().v4();
  File image;

  Future<File> getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return image = File(pickedFile.path);
  }

  Future<File> getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return image = File(pickedFile.path);
  }

  clearImage() {
    image = null;
  }

  Future<File> compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 50));

    return image = compressedImageFile;
  }

  Future<String> uploadImageToFirebase(File file) async {
    String fileName = basename(file.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);

    String downloadUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
