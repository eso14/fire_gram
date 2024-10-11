import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  
  // Uploads the user profile image to Firebase after compressing it
  static Future<String> uploadUserProfileImage(String url, File imageFile) async {
    String photoId = Uuid().v4();  // Generates a unique ID for the image

    if (url.isNotEmpty) {
      // Updating the existing user profile image if a URL exists
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      String? photoId = exp.firstMatch(url)?[1]; // Extract the photoId from the existing URL
    }
    
    // Compress the image before uploading
    XFile? compressedImage = await compressImage(photoId, imageFile);
    
    // Upload the image to Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(compressedImage as File);
    
    // Await the upload task and get the download URL
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    
    return downloadUrl;  // Return the URL of the uploaded image
  }

  // Compress the image using flutter_image_compress
  static Future<XFile?> compressImage(String photoId, File imageFile) async {
    final tempDir = await getTemporaryDirectory();  // Get temporary directory to store the compressed file
    final path = tempDir.path;
    
    // Compress the image to 70% quality
    XFile? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70, // Compression quality level (lower means more compression)
    );
    
    return compressedImageFile;  // Return the compressed image file
  }
}
