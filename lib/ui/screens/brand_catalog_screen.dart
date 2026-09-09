import 'package:flutter/material.dart';
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
        "black_casualshirt_men.png",
        "black_waiscoat_men.png",
        "Blue kurti Women.png",
        "Blue Long Suite Women.png",
        "blue_waiscoat_men.png",
        "cream_casualshirt_men.png",
        "cream_kurta_men.png",
        "dark_kurta_men.png",
        "Green Suite Women.png",
        "light_green_casualshirt_men.png",
        "mehroon_shalwar_kameez_men.png",
        "off_white_kurta_men.png",
        "Pink Suite Women.png.jpg",
        "Purple Suite Women.png.jpg",
        "Purple White Suite Women.png",
        "Red Dress Women.png",
        "Red Long Suite Women.png",
        "silver_pine_shalwar_kameez_men.png",
        "skin_waiscoat_men.png",
        "white_shalwar_kameez_men.png",
        "Yellow Dress Women.png",
        "Yellow Shirt Women.png",
      ];
    } else if (widget.brandName == "Breakout") {
      fileNames = [
        "black shirt men.png",
        "black shirt women.png",
        "black sweatshirt women.png",
        "black tee men.png",
        "brown sweat shirt men.png",
        "brown tees women.png",
        "green top women.png",
        "grey polos men.png",
        "grey shirt men.png",
        "grey tees women.png",
        "grey weatshirt men.png",
        "mehroon top women.png",
        "navy sweatshirt women.png",
        "red sweatshirt men.png",
        "skin shirt women.png",
        "skin tees women.png",
        "sky blue shirt men.png",
        "whit brown lines tees men.png",
        "white cream polos men.png",
        "white polos men.png",
        "white shirt women.png",
        "white sweatshirt women.png",
        "white tees men.png",
        "yellow top women.png",
      ];
    } else if (widget.brandName == "Outfitters") {
      fileNames = [
        "black brown active wear women.png",
        "black jump suit women.png",
        "black shirt women.png",
        "black t-shirt men.png",
        "blue active wear men.png",
        "blue black jump suit women.png",
        "blue shirt women.png",
        "brown red active wear women.png",
        "dark blue brown active wear women.png",
        "green active wear men.png",
        "green shirt men.png",
        "mehroon polo shirt men.png",
        "pink t-shirt men.png",
        "skin t-shirt women.png",
        "white active wear tank top men.png",
        "white flower shirt men.png",
        "white jump suit women.png",
        "white polo shirt men.png",
        "white purple t-shirts women.png",
        "white shirt men.png",
        "white shirt women.png",
        "white t-shirt men.png",
        "white t-shirts women.png",
        "yellow polo shirt men.png",
      ];
    } else if (widget.brandName == "Chase Value") {
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
      ];
    }

    String folderName = widget.brandName;
    if (folderName == "Chase Value") {
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
                                itemTitle: item['title']!,
                                itemImagePath: item['image']!,
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
                                child: ClipRRect(
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
