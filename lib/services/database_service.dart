import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Get chat history stream
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

  // Get wardrobe items stream
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
}
