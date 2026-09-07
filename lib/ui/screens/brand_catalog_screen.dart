import 'package:flutter/material.dart';

class BrandCatalogScreen extends StatefulWidget {
  final String brandName;

  const BrandCatalogScreen({super.key, required this.brandName});

  @override
  State<BrandCatalogScreen> createState() => _BrandCatalogScreenState();
}

class _BrandCatalogScreenState extends State<BrandCatalogScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

  // Brand item list
  final Map<String, List<Map<String, dynamic>>> brandData = {
    "Ideas": [
      {"title": "Ideas Men Shalwar Kameez", "icon": Icons.accessibility_new},
      {"title": "Ideas Formal Shirt", "icon": Icons.checkroom},
      {"title": "Ideas Lawn Kurti", "icon": Icons.female},
      {"title": "Ideas Festive Suit", "icon": Icons.person},
      {"title": "Ideas Casual Kurta", "icon": Icons.man},
      {"title": "Ideas Luxury Maxi", "icon": Icons.woman},
    ],
    "Breakout": [
      {"title": "Breakout Casual Tee", "icon": Icons.man},
      {"title": "Breakout Denim Jacket", "icon": Icons.checkroom},
      {"title": "Breakout Western Top", "icon": Icons.woman},
      {"title": "Breakout Party Dress", "icon": Icons.female},
      {"title": "Breakout Cargo Pants", "icon": Icons.accessibility_new},
    ],
    "Outfitters": [
      {"title": "Outfitters Hoodie", "icon": Icons.accessibility_new},
      {"title": "Outfitters Cargo Pants", "icon": Icons.checkroom},
      {"title": "Outfitters Summer Dress", "icon": Icons.female},
      {"title": "Outfitters Casual Jumpsuit", "icon": Icons.person},
      {"title": "Outfitters Graphic Tee", "icon": Icons.man},
    ],
    "Chase Value": [
      {"title": "Chase Value Basic Kurta", "icon": Icons.accessibility_new},
      {"title": "Chase Value Daily Wear Tee", "icon": Icons.checkroom},
      {"title": "Chase Value Printed Suit", "icon": Icons.female},
      {"title": "Chase Value Maxi", "icon": Icons.person},
    ],
  };

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Get item form brand
    List<Map<String, dynamic>> items = brandData[widget.brandName] ?? [];

    // Filter item
    final filteredItems = items.where((item) {
      final titleLower = item['title'].toLowerCase();
      final query = searchQuery.toLowerCase();
      return titleLower.contains(query);
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "${widget.brandName} Collection",
          style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primaryPurple),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search in ${widget.brandName}...",
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: primaryPurple),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: primaryPurple.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: primaryPurple.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: primaryPurple, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "All Items",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 12),

                // Grid of diff brands
                Expanded(
                  child: filteredItems.isEmpty
                      ? const Center(
                    child: Text(
                      "No items found.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                      : GridView.builder(
                    itemCount: filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product image
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryPurple.withOpacity(0.08),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Icon(
                                    item['icon'],
                                    size: 45,
                                    color: primaryPurple,
                                  ),
                                ),
                              ),
                            ),
                            // Item Name
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                item['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}