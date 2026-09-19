import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/local_catalog_service.dart';
import 'virtual_try_on_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final String? gender;

  const CategoryScreen({super.key, required this.categoryName, this.gender});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

  String searchQuery = "";
  late Stream<Object> _wardrobeStream;
  late List<Map<String, String>> _catalogItems;

  @override
  void initState() {
    super.initState();
    _catalogItems = LocalCatalogService.getAllCatalogItems();
    _wardrobeStream = DatabaseService().getWardrobeItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.categoryName == "Global Search" ? "Search Results" : "${widget.categoryName} Collection",
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
          child: Builder(
            builder: (context) {
              // Initial filter by category
              var categoryItems = _catalogItems.where((item) {
                final titleLower = item['title']!.toLowerCase();
                
                if (widget.gender != null) {
                  final RegExp genderRegex = RegExp(r'\b' + widget.gender!.toLowerCase() + r'\b');
                  if (!genderRegex.hasMatch(titleLower)) {
                    return false;
                  }
                }

                // Simple keyword matching based on category
                if (widget.categoryName == "Shalwar Kameez") {
                  return titleLower.contains("shalwar") || titleLower.contains("kameez") || titleLower.contains("kurta") || titleLower.contains("kurti");
                } else if (widget.categoryName == "Shirts") {
                  return titleLower.contains("shirt") || titleLower.contains("tee") || titleLower.contains("polo") || titleLower.contains("top");
                } else if (widget.categoryName == "Dresses") {
                  return titleLower.contains("dress") || titleLower.contains("co-ords") || titleLower.contains("jump suit");
                } else if (widget.categoryName == "Suits") {
                  return titleLower.contains("suite") || titleLower.contains("suit");
                } else if (widget.categoryName == "Global Search") {
                  return true;
                }
                return titleLower.contains(widget.categoryName.toLowerCase());
              }).toList();

              final filteredItems = categoryItems.where((item) {
                final titleLower = item['title']!.toLowerCase();
                final query = searchQuery.toLowerCase();
                return titleLower.contains(query);
              }).toList();

              return StreamBuilder<Object>(
                stream: _wardrobeStream,
                builder: (context, snapshot) {
                  Set<String> savedItems = {};
                  if (snapshot.hasData) {
                    final docs = (snapshot.data as dynamic).docs;
                    for (var doc in docs) {
                      savedItems.add(doc['imagePath'] as String);
                    }
                  }

              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight + 10.0, bottom: 10.0),
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
                        hintText: widget.categoryName == "Global Search" ? "Search all brands..." : "Search in ${widget.categoryName}...",
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
                          final isSaved = savedItems.contains(item['image']);

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
                                          child: item['image']!.startsWith('http')
                                              ? Image.network(
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
                                                )
                                              : Image.asset(
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
                                              if (isSaved) {
                                                await DatabaseService().removeByImagePath(item['image']!);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Removed from Wardrobe!"),
                                                    backgroundColor: Colors.grey,
                                                  ),
                                                );
                                              } else {
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
                                              }
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
                                              child: Icon(
                                                isSaved ? Icons.favorite : Icons.favorite_border,
                                                size: 20,
                                                color: const Color(0xFFE91E63),
                                              ),
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
              );
                },
              );
            }
          ),
        ),
      ),
    );
  }
}
