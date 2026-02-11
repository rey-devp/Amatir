import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for saving proof-of-delivery images locally on the device.
///
/// Images are stored in the app's documents directory under a `proofs/` folder.
/// The local file path is returned and saved to Firestore as `proof_url`.
class StorageService {
  /// Saves an [XFile] (from image_picker) to the local app folder.
  ///
  /// Returns the absolute local file path for storage in Firestore.
  Future<String> saveImageLocally(XFile xFile) async {
    try {
      // 1. Get the app's persistent documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String proofsDir = p.join(appDir.path, 'proofs');

      // 2. Create the proofs folder if it doesn't exist
      final Directory dir = Directory(proofsDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // 3. Generate unique filename
      final String uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(xFile.path)}';
      final String savedPath = p.join(proofsDir, uniqueName);

      // 4. Copy image to permanent location
      final File sourceFile = File(xFile.path);
      await sourceFile.copy(savedPath);

      debugPrint('✅ Image saved locally: $savedPath');
      return savedPath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  /// Checks if a local proof image file exists.
  Future<bool> proofExists(String path) async {
    return File(path).exists();
  }
}