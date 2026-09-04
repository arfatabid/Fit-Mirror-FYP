import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Left side 3 bars/drawer icon remove karne ke liye
        title: Text(
          "Fit Mirror",
          style: TextStyle(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE1BEE7).withOpacity(0.4),
                        Colors.white.withOpacity(0.9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: primaryPurple.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for products, brands a...",
                      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: primaryPurple),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Promotional Banner Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Collection",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryPurple,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Elevate Your\nEveryday Style",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Trendy picks, top brands &\nexclusive deals.",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Shop Now",
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.shopping_bag, size: 85, color: primaryPurple.withOpacity(0.85)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Top Brands Section
                const Text(
                  "Top Brands",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildBrandItem("Ideas", Icons.checkroom, const Color(0xFFFCE4EC), accentPink),
                      _buildBrandItem("Breakout", Icons.style, const Color(0xFFFFF3E0), Colors.orange),
                      _buildBrandItem("Outfitters", Icons.groups, const Color(0xFFE3F2FD), Colors.blue),
                      _buildBrandItem("Chase Value", Icons.storefront, const Color(0xE8E8F8E8), Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Men Category Section
                Center(
                  child: Text(
                    "Men Category",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Shalwar Kameez", Icons.dry_cleaning)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("Shirts", Icons.checkroom)),
                  ],
                ),

                const SizedBox(height: 28),

                // Women Category Section
                Center(
                  child: Text(
                    "Women Category",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Dresses", Icons.style)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("Suits", Icons.checkroom_outlined)),
                  ],
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(
            Icons.home_filled,
            size: 28,
            color: _currentIndex == 0 ? Colors.white : primaryPurple.withOpacity(0.7),
          ),
          Icon(
            Icons.support_agent,
            size: 28,
            color: _currentIndex == 1 ? Colors.white : primaryPurple.withOpacity(0.7),
          ),
          Icon(
            Icons.camera_alt,
            size: 28,
            color: _currentIndex == 2 ? Colors.white : primaryPurple.withOpacity(0.7),
          ),
          Icon(
            Icons.checkroom,
            size: 28,
            color: _currentIndex == 3 ? Colors.white : primaryPurple.withOpacity(0.7),
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: primaryPurple,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Brand Circle Item Builder
  Widget _buildBrandItem(String title, IconData icon, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Category Card Builder
  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.favorite_border, size: 18, color: Colors.grey.shade400),
          ),
          Expanded(
            child: Center(
              child: Icon(
                icon,
                size: 70,
                color: primaryPurple,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}