import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Save chat message
  Future<void> saveChatMessage(String text, String role) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('AssistantChats').doc(user.uid).collection('messages').add({
        'text': text,
        'role': role,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get chat history 
  Stream<QuerySnapshot> getChatMessages() {
    final user = _auth.currentUser;
    if (user != null) {
      return _db.collection('AssistantChats')
          .doc(user.uid)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  // Save item to wardrobe
  Future<void> addToWardrobe({required String name, required String imagePath}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).collection('wardrobe').add({
        'name': name,
        'imagePath': imagePath,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Remove item from wardrobe
  Future<void> removeFromWardrobe(String docId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).collection('wardrobe').doc(docId).delete();
    }
  }

  // Remove item from wardrobe by imagePath
  Future<void> removeByImagePath(String imagePath) async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _db
          .collection('users')
          .doc(user.uid)
          .collection('wardrobe')
          .where('imagePath', isEqualTo: imagePath)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  // Get wardrobe items 
  Stream<QuerySnapshot> getWardrobeItems() {
    final user = _auth.currentUser;
    if (user != null) {
      return _db.collection('users')
          .doc(user.uid)
          .collection('wardrobe')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  // --- ADMIN FEATURES ---

  // Check if a user is blocked
  Future<bool> isUserBlocked(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['isBlocked'] ?? false;
    }
    return false;
  }

  // Block/Unblock a user
  Future<void> updateUserStatus(String uid, bool isBlocked) async {
    await _db.collection('users').doc(uid).update({
      'isBlocked': isBlocked,
    });
  }

  // Analytics: Increment Try-On Count
  Future<void> incrementTryOnCount() async {
    final docRef = _db.collection('analytics').doc('stats');
    
    // Using a transaction to safely increment
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        transaction.set(docRef, {'totalTryOns': 1});
      } else {
        final currentCount = snapshot.data()?['totalTryOns'] ?? 0;
        transaction.update(docRef, {'totalTryOns': currentCount + 1});
      }
    });
  }

  // Get Analytics Stream
  Stream<DocumentSnapshot> getAnalyticsStats() {
    return _db.collection('analytics').doc('stats').snapshots();
  }

  // Storage: Upload Brand Image
  Future<String?> uploadBrandImage(File imageFile, String brandName, String dressName) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${dressName.replaceAll(" ", "_")}.png';
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('Brands')
        .child(brandName)
        .child(fileName);

    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    
    // Save metadata to Firestore catalog collection
    await _db.collection('catalog').add({
      'title': dressName,
      'image': downloadUrl,
      'brand': brandName,
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    return downloadUrl;
  }

  // --- CATALOG FETCHING ---

  // Get all catalog items
  Stream<QuerySnapshot> getAllCatalogItems() {
    return _db.collection('catalog').orderBy('timestamp', descending: true).snapshots();
  }

  // Get catalog items by brand
  Stream<QuerySnapshot> getBrandCatalogItems(String brandName) {
    return _db.collection('catalog')
        .where('brand', isEqualTo: brandName)
        .snapshots(); // Note: Cannot easily order by timestamp when filtering by equality without a composite index, so just sort in dart or use snapshots directly
  }

  // --- ONE TIME MIGRATION SCRIPT ---
  Future<void> migrateLocalAssetsToFirestore() async {
    final snapshot = await _db.collection('catalog').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print("Catalog already migrated");
      return; // Already migrated
    }

    print("Starting catalog migration...");
    final brands = ["Ideas", "Breakout", "Outfitters", "ChaseValue"];
    
    for (var brand in brands) {
      List<String> fileNames = [];
      if (brand == "Ideas") {
        fileNames = [
          "Black & White Dress Women.png", "Black Kurti Women.png", "Black CasualShirt Men.png",
          "Black WaisCoat Men.png", "Blue kurti Women.png", "Blue Long Suite Women.png",
          "Blue WaisCoat Men.png", "Cream CasualShirt Men.png", "Cream Kurta Men.png",
          "Dark Kurta Men.png", "Green Suite Women.png", "Light Green CasualShirt Men.png",
          "Mehroon Shalwar Kameez Men.png", "Off White Kurta Men.png", "Pink Suite Women.png",
          "Purple Suite Women.png", "Purple White Suite Women.png", "Red Dress Women.png",
          "Red Long Suite Women.png", "Silver Pine Shalwar Kameez Men.png", "Skin WaisCoat Men.png",
          "White Shalwar Kameez Men.png", "Yellow Dress Women.png", "Yellow Shirt Women.png",
        ];
      } else if (brand == "Breakout") {
        fileNames = [
          "Black Shirt Men.png", "Black Shirt Women.png", "Black SweatShirt Women.png",
          "Black Tee Men.png", "Brown SweatShirt Men.png", "Brown Tees Women.png",
          "Green Top Women.png", "Grey Polos Men.png", "Grey Shirt Men.png",
          "Grey Tees Women.png", "Grey SweatShirt Men.png", "Mehroon Top Women.png",
          "Navy Sweatshirt Women.png", "Red SweatShirt Men.png", "Skin Shirt Women.png",
          "Skin Tees Women.png", "Sky Blue Shirt Men.png", "White Brown Lines Tees Men.png",
          "White Cream Polos Men.png", "White Polos Men.png", "White Shirt Women.png",
          "White SweatShirt Women.png", "White Tees Men.png", "Yellow Top Women.png",
        ];
      } else if (brand == "Outfitters") {
        fileNames = [
          "Black Brown Active Wear Women.png", "Black Jump Suit Women.png", "Black Shirt Women.png",
          "Black T-Shirt Men.png", "Blue Active Wear Men.png", "Blue Black Jump Suit Women.png",
          "Blue Shirt Women.png", "Brown Red Active Wear Women.png", "Dark Blue Brown Active Wear Women.png",
          "Green Active Wear Men.png", "Green Shirt Men.png", "Mehroon Polo Shirt Men.png",
          "Pink T-Shirt Men.png", "Skin T-Shirt Women.png", "White Active Wear Tank Top Men.png",
          "White Flower Shirt Men.png", "White Jump Suit Women.png", "White Polo Shirt Men.png",
          "White Purple T-Shirts Women.png", "White Shirt Men.png", "White Shirt Women.png",
          "White T-Shirt Men.png", "White T-Shirts Women.png", "Yellow Polo Shirt Men.png",
        ];
      } else if (brand == "ChaseValue") {
        fileNames = [
          "black co-ords women.png", "black red tracksuit women.png", "blue kurti women.png",
          "blue red t-shirt women.png", "blue t-shirt women.png", "brown t-shirt women.png",
          "chasevalue men kameez shalwar brown.png", "chasevalue men kameez shalwar grey.png",
          "chasevalue men kameez shalwar white.png", "chasevalue men kurta black.png",
          "chasevalue men kurta brown.png", "chasevalue men kurta grey.png",
          "chasevalue men polo shirt black.png", "chasevalue men polo shirt blue.png",
          "chasevalue men polo shirt white.png", "chasevalue men waist coat black.png",
          "chasevalue men waist coat brown.png", "green tracksuit women.png",
          "grey co-ords women.png", "grey kurti women.png", "mehroon kurti women.png",
          "orange co-ords women.png", "purple t-shirt women.png", "white strip shirt men.png",
        ];
      }
      
      for (var file in fileNames) {
        String title = file.replaceAll(RegExp(r'\.(png|jpg|jpeg)', caseSensitive: false), '');
        await _db.collection('catalog').add({
          "title": title,
          "image": "assets/Brands/$brand/$file",
          "brand": brand,
          "timestamp": FieldValue.serverTimestamp(),
        });
      }
    }
    print("Catalog migration complete!");
  }
}
