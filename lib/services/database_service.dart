import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Save message
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

  // chat history
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

  //  Admin Side

  // Check if user is blocked
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

  // Increment Try-On Count
  Future<void> incrementTryOnCount() async {
    final docRef = _db.collection('analytics').doc('stats');
    
    // transaction to safely increment
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

  // Get Stream
  Stream<DocumentSnapshot> getAnalyticsStats() {
    return _db.collection('analytics').doc('stats').snapshots();
  }

  // Product Management (ADMIN)

  // Upload product image to Firebase Storage
  Future<String> uploadProductImage(File imageFile, String brandName, String productName) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('Brands')
        .child(brandName)
        .child('$productName.png');

    final uploadTask = await storageRef.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  // Add Product to Firestore
  Future<void> addProduct(String brandName, String productName, String imageUrl) async {
    await _db.collection('catalog').add({
      'brand': brandName,
      'title': productName,
      'image': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Delete Product from Firestore
  Future<void> deleteProduct(String productID) async {
    await _db.collection('catalog').doc(productID).delete();
  }

  // Get all catalog items
  Stream<QuerySnapshot> getAllCatalogItems() {
    return _db.collection('catalog')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get catalog items for specific brand
  Stream<QuerySnapshot> getBrandCatalogItems(String brandName) {
    return _db.collection('catalog')
        .where('brand', isEqualTo: brandName)
        .snapshots();
  }
}
