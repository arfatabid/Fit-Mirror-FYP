import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import 'virtual_try_on_screen.dart';

class BrandCatalogScreen extends StatefulWidget {
  final String brandName;

  const BrandCatalogScreen({super.key, required this.brandName});

  @override
  State<BrandCatalogScreen> createState() => _BrandCatalogScreenState();
}

class _BrandCatalogScreenState extends State<BrandCatalogScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

  List<Map<String, String>> _getBrandItems() {
    List<String> fileNames = [];

    if (widget.brandName == "Ideas") {
      fileNames = [
        "Black & White Dress Women.png",
        "Black Kurti Women.png",
        "Black CasualShirt Men.png",
        "Black WaisCoat Men.png",
        "Blue kurti Women.png",
        "Blue Long Suite Women.png",
        "Blue WaisCoat Men.png",
        "Cream CasualShirt Men.png",
        "Cream Kurta Men.png",
        "Dark Kurta Men.png",
        "Green Suite Women.png",
        "Light Green CasualShirt Men.png",
        "Mehroon Shalwar Kameez Men.png",
        "Off White Kurta Men.png",
        "Pink Suite Women.png",
        "Purple Suite Women.png",
        "Purple White Suite Women.png",
        "Red Dress Women.png",
        "Red Long Suite Women.png",
        "Silver Pine Shalwar Kameez Men.png",
        "Skin WaisCoat Men.png",
        "White Shalwar Kameez Men.png",
        "Yellow Dress Women.png",
        "Yellow Shirt Women.png",
      ];
    } else if (widget.brandName == "Breakout") {
      fileNames = [
        "Black Shirt Men.png",
        "Black Shirt Women.png",
        "Black SweatShirt Women.png",
        "Black Tee Men.png",
        "Brown SweatShirt Men.png",
        "Brown Tees Women.png",
        "Green Top Women.png",
        "Grey Polos Men.png",
        "Grey Shirt Men.png",
        "Grey Tees Women.png",
        "Grey SweatShirt Men.png",
        "Mehroon Top Women.png",
        "Navy Sweatshirt Women.png",
        "Red SweatShirt Men.png",
        "Skin Shirt Women.png",
        "Skin Tees Women.png",
        "Sky Blue Shirt Men.png",
        "White Brown Lines Tees Men.png",
        "White Cream Polos Men.png",
        "White Polos Men.png",
        "White Shirt Women.png",
        "White SweatShirt Women.png",
        "White Tees Men.png",
        "Yellow Top Women.png",
      ];
    } else if (widget.brandName == "Outfitters") {
      fileNames = [
        "Black Brown Active Wear Women.png",
        "Black Jump Suit Women.png",
        "Black Shirt Women.png",
        "Black T-Shirt Men.png",
        "Blue Active Wear Men.png",
        "Blue Black Jump Suit Women.png",
        "Blue Shirt Women.png",
        "Brown Red Active Wear Women.png",
        "Dark Blue Brown Active Wear Women.png",
        "Green Active Wear Men.png",
        "Green Shirt Men.png",
        "Mehroon Polo Shirt Men.png",
        "Pink T-Shirt Men.png",
        "Skin T-Shirt Women.png",
        "White Active Wear Tank Top Men.png",
        "White Flower Shirt Men.png",
        "White Jump Suit Women.png",
        "White Polo Shirt Men.png",
        "White Purple T-Shirts Women.png",
        "White Shirt Men.png",
        "White Shirt Women.png",
        "White T-Shirt Men.png",
        "White T-Shirts Women.png",
        "Yellow Polo Shirt Men.png",
      ];
    } else if (widget.brandName == "ChaseValue") {
      fileNames = [
        "black co-ords women.png",
        "black red tracksuit women.png",
        "blue kurti women.png",
        "blue red t-shirt women.png",
        "blue t-shirt women.png",
        "brown t-shirt women.png",
        "chasevalue men kameez shalwar brown.png",
        "chasevalue men kameez shalwar grey.png",
        "chasevalue men kameez shalwar white.png",
        "chasevalue men kurta black.png",
        "chasevalue men kurta brown.png",
        "chasevalue men kurta grey.png",
        "chasevalue men polo shirt black.png",
        "chasevalue men polo shirt blue.png",
        "chasevalue men polo shirt white.png",
        "chasevalue men waist coat black.png",
        "chasevalue men waist coat brown.png",
        "green tracksuit women.png",
        "grey co-ords women.png",
        "grey kurti women.png",
        "mehroon kurti women.png",
        "orange co-ords women.png",
        "purple t-shirt women.png",
        "white strip shirt men.png",
      ];
    }

    String folderName = widget.brandName;
    if (folderName == "ChaseValue") {
      folderName = "ChaseValue";
    }

    return fileNames.map((file) {
      String title = file.replaceAll(RegExp(r'\.(png|jpg|jpeg)', caseSensitive: false), '');
      return {
        "title": title,
        "image": "assets/Brands/$folderName/$file",
      };
    }).toList();
  }

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = _getBrandItems();

    final filteredItems = items.where((item) {
      final titleLower = item['title']!.toLowerCase();
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                  "All Items (${filteredItems.length})",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 12),
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
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VirtualTryOnScreen(
                                garmentImageUrl: item['image']!,
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.asset(
                                        item['image']!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: primaryPurple.withOpacity(0.08),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.image_not_supported, size: 28, color: primaryPurple),
                                                  const SizedBox(height: 4),
                                                  const Text("Not Found", style: TextStyle(fontSize: 9, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await DatabaseService().addToWardrobe(
                                            name: item['title']!,
                                            imagePath: item['image']!,
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Saved to Wardrobe!"),
                                              backgroundColor: Color(0xFFE91E63),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.favorite_border, size: 20, color: Color(0xFFE91E63)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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
