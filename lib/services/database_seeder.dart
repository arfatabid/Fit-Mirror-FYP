import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_catalog_service.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase() async {
    final List<Map<String, String>> allItems = LocalCatalogService.getAllCatalogItems();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    
    print("Starting database seeding: ${allItems.length} items found...");

    int count = 0;
    for (var item in allItems) {
      String brandName = item['brand']!;
      String title = item['title']!;
      String assetPath = item['image']!;
      
      try {
        print("Uploading $title...");
        
        // Read asset from rootBundle
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();
        
        // Upload to Storage
        final storageRef = storage.ref().child('Brands').child(brandName).child('$title.png');
        final uploadTask = await storageRef.putData(bytes, SettableMetadata(contentType: 'image/png'));
        
        // Get URL
        final String downloadUrl = await uploadTask.ref.getDownloadURL();
        
        // Create Firestore document
        await db.collection('catalog').add({
          'brand': brandName,
          'title': title,
          'image': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        count++;
        print("Successfully added: $title ($count/${allItems.length})");
        
      } catch (e) {
        print("Failed to upload $title: $e");
      }
    }
    
    print("Database Seeding Completed! Successfully uploaded $count items.");
  }
}
