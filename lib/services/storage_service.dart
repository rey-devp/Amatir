
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String folderName) async {
    try {
     
      String fileName = path.basename(file.path);
      
      // Buat referensi lokasi file di Firebase Storage
      // Format: folderName/timestamp_filename
      String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      Reference ref = _storage.ref().child('$folderName/$uniqueFileName');

      UploadTask uploadTask = ref.putFile(file);
      
      TaskSnapshot snapshot = await uploadTask;

      // Ambil URL download agar bisa disimpan di Firestore
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }
}