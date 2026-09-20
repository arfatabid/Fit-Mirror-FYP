import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/database_service.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF5E35B1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryPurple));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final users = snapshot.data?.docs ?? [];
          
          if (users.isEmpty) {
            return const Center(child: Text("No users found. (Old users may not appear here)"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final email = userData['email'] ?? 'Unknown Email';
              final role = userData['role'] ?? 'user';
              final isBlocked = userData['isBlocked'] ?? false;
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isBlocked ? Colors.red.withOpacity(0.2) : primaryPurple.withOpacity(0.2),
                    child: Icon(Icons.person, color: isBlocked ? Colors.red : primaryPurple),
                  ),
                  title: Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Role: $role ${isBlocked ? '(Blocked)' : ''}", style: TextStyle(color: isBlocked ? Colors.red : Colors.black54)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(isBlocked ? Icons.lock_open : Icons.block, color: isBlocked ? Colors.green : Colors.orange),
                        onPressed: () async {
                          final db = DatabaseService();
                          await db.updateUserStatus(users[index].id, !isBlocked);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          // Delete user document from Firestore (Warning: This doesn't delete Firebase Auth account)
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete User Record"),
                              content: const Text("This will remove the user from the database. Proceed?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.collection('users').doc(users[index].id).delete();
                                    if (context.mounted) Navigator.pop(ctx);
                                  },
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
