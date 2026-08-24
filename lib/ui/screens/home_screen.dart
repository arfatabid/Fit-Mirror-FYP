import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'virtual_try_on_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Color primaryPurple = const Color(0xFF4A2E7A);
  final Color accentPink = const Color(0xFFE91E63);
  final Color bgLavender = const Color(0xFFF7F5FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLavender,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text(
          "Fit Mirror",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            const Text(
              "Welcome Back,",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              "arfatabid19@gmail.com",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search clothes, brands, styles...",
                prefixIcon: Icon(Icons.search, color: primaryPurple),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: accentPink.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: accentPink.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: accentPink),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Brand Catalog Section
            Text(
              "Browse Product Catalog by Brands",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBrandItem("Brand A", Icons.design_services),
                _buildBrandItem("Brand B", Icons.group),
                _buildBrandItem("Brand C", Icons.radio_button_unchecked),
                _buildBrandItem("Brand D", Icons.texture),
              ],
            ),
            const SizedBox(height: 24),

            // Category - Men Section
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Shop by Category - Men",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCategoryItem("Shalwar Kameez", Icons.accessibility_new, Colors.lightBlue),
                const SizedBox(width: 16),
                _buildCategoryItem("Shirts", Icons.checkroom, primaryPurple),
              ],
            ),
            const SizedBox(height: 24),

            // Category - Women Section
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Shop by Category - Women",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCategoryItem("Dresses", Icons.female, accentPink),
                const SizedBox(width: 16),
                _buildCategoryItem("Suits", Icons.person, primaryPurple),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Jab user 'Try-On' (index 2) par click karega toh Virtual Try-On screen khul jaye gi
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VirtualTryOnScreen()),
            );
          }
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

  Widget _buildBrandItem(String name, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryPurple.withOpacity(0.5), width: 1.5),
            color: Colors.white,
          ),
          child: Icon(icon, color: primaryPurple),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}