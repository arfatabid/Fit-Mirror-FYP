import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  // Theme Colors
  final Color bgLavender = const Color(0xFFF7F5FC);
  final Color primaryPurple = const Color(0xFF4A2E7A);
  final Color accentPink = const Color(0xFFE91E63);

  @override
  Widget build(BuildContext context) {
    String userEmail = user?.email ?? "arfatabid19@gmail.com";

    return Scaffold(
      backgroundColor: bgLavender,
      // Professional Dark App Bar
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: accentPink),
            const SizedBox(width: 8),
            const Text(
              "Fit Mirror",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Text(
              "Welcome Back,\n$userEmail",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search clothes, brands, styles...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: primaryPurple),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: accentPink.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: accentPink, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),

            // Browse Product Catalog by Brands
            Text(
              'Browse Product Catalog by Brands',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 105,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildBrandCircularItem('Brand A', Icons.design_services),
                  _buildBrandCircularItem('Brand B', Icons.group),
                  _buildBrandCircularItem('Brand C', Icons.circle_outlined),
                  _buildBrandCircularItem('Brand D', Icons.texture),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shop by Category: MEN SECTION (Blue Theme)
            Row(
              children: [
                Container(width: 4, height: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Shop by Category - Men',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCategoryCircularItem('Shalwar Kameez', Icons.checkroom, Colors.blue.shade300),
                const SizedBox(width: 20),
                _buildCategoryCircularItem('Shirts', Icons.dry_cleaning, primaryPurple),
              ],
            ),
            const SizedBox(height: 24),

            // Shop by Category: WOMEN SECTION (Pink Theme)
            Row(
              children: [
                Container(width: 4, height: 16, color: accentPink),
                const SizedBox(width: 8),
                Text(
                  'Shop by Category - Women',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCategoryCircularItem('Dresses', Icons.woman, accentPink),
                const SizedBox(width: 20),
                _buildCategoryCircularItem('Suits', Icons.man, primaryPurple.withOpacity(0.9)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Professional Dark Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryPurple,
        selectedItemColor: accentPink,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Try-On',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
          ),
        ],
      ),
    );
  }

  // Helper Widget for Circular Brand Items
  Widget _buildBrandCircularItem(String brandTitle, IconData brandIcon) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.purple.shade200, width: 1.5),
            ),
            child: Icon(brandIcon, color: primaryPurple, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            brandTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryPurple),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Circular Category Items
  Widget _buildCategoryCircularItem(String title, IconData icon, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: primaryPurple,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}