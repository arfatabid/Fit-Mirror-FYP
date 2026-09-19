import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/database_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF5E35B1);
    final db = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Analytics"),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Users Count
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                int totalUsers = 0;
                if (snapshot.hasData) {
                  totalUsers = snapshot.data!.docs.length;
                }
                return _buildStatCard(
                  "Total Users",
                  totalUsers.toString(),
                  Icons.people,
                  Colors.blue,
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Try-Ons Count
            StreamBuilder<DocumentSnapshot>(
              stream: db.getAnalyticsStats(),
              builder: (context, snapshot) {
                int totalTryOns = 0;
                if (snapshot.hasData && snapshot.data!.exists) {
                  totalTryOns = (snapshot.data!.data() as Map<String, dynamic>)['totalTryOns'] ?? 0;
                }
                return _buildStatCard(
                  "Total Try-Ons",
                  totalTryOns.toString(),
                  Icons.checkroom,
                  Colors.pink,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
