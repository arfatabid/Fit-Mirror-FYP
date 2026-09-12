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
}
