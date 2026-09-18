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

  String searchQuery = "";
  late Stream<Object> _catalogStream;
  late Stream<Object> _wardrobeStream;

  @override
  void initState() {
    super.initState();
    _catalogStream = DatabaseService().getBrandCatalogItems(widget.brandName);
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
          child: StreamBuilder<Object>(
            stream: _catalogStream,
            builder: (context, catalogSnapshot) {
              if (catalogSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryPurple));
              }
              
              if (catalogSnapshot.hasError) {
                return const Center(child: Text("Error loading catalog"));
              }

              final catalogDocs = (catalogSnapshot.data as dynamic)?.docs ?? [];
              
              List<Map<String, String>> items = catalogDocs.map<Map<String, String>>((doc) {
                return {
                  "title": doc['title'].toString(),
                  "image": doc['image'].toString(),
                };
              }).toList();

              final filteredItems = items.where((item) {
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
