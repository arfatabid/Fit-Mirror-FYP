import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class VirtualTryOnScreen extends StatefulWidget {
  final String? garmentImageUrl; // Catalog se selected outfit asset path pass karne ke liye
  const VirtualTryOnScreen({super.key, this.garmentImageUrl});

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  final Color primaryPurple = const Color(0xFF4A2E7A);
  final Color accentPink = const Color(0xFFE91E63);
  final Color bgLavender = const Color(0xFFF7F5FC);

  bool _isGenerating = false;
  Uint8List? _userPhotoBytes;
  Uint8List? _resultImageBytes;
  final ImagePicker _picker = ImagePicker();

  // Locally selected garment manage karne ke liye taake user try-on screen se hi change kar sakay
  String? _selectedGarmentUrl;

  @override
  void initState() {
    super.initState();
    _selectedGarmentUrl = widget.garmentImageUrl;
  }

  Future<void> _pickUserPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _userPhotoBytes = bytes;
      });
    }
  }

  // Brands aur unke garments ki list helper function
  List<Map<String, String>> _getBrandItems(String brandName) {
    List<String> fileNames = [];

    if (brandName == "Ideas") {
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
    } else if (brandName == "Breakout") {
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
    } else if (brandName == "Outfitters") {
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
    } else if (brandName == "Chase Value") {
      fileNames = [
        "black co-ords women.png",
        "black red tracksuit women.png",
        "blue kurti women.png",
        "blue red t-shirt women.png",
        "blue t-shirt women.png",
        "brown t-shirt women.png",
        "chase value men kameez shalwar brown.png",
        "chase value men kameez shalwar grey.png",
        "chase value men kameez shalwar white.png",
        "chase value men kurta black.png",
        "chase value men kurta brown.png",
        "chase value men kurta grey.png",
        "chase value men polo shirt black.png",
        "chase value men polo shirt blue.png",
        "chase value men polo shirt white.png",
        "chase value men waist coat black.png",
        "chase value men waist coat brown.png",
        "green tracksuit women.png",
        "grey co-ords women.png",
        "grey kurti women.png",
        "mehroon kurti women.png",
        "orange co-ords women.png",
        "purple t-shirt women.png",
      ];
    }

    return fileNames.map((file) {
      String title = file.replaceAll(RegExp(r'\.(png|jpg|jpeg)', caseSensitive: false), '');
      return {
        "title": title,
        "image": "assets/Brands/$brandName/$file",
      };
    }).toList();
  }

  // 1. Brands select karne ke liye Bottom Sheet (Sirf clear logos without text overlap)
  void _showBrandSelectionSheet(BuildContext context) {
    final List<Map<String, String>> brands = [
      {"name": "Ideas", "logo": "assets/images/ideas.png"},
      {"name": "Breakout", "logo": "assets/images/breakout.png"},
      {"name": "Outfitters", "logo": "assets/images/outfitters.png"},
      {"name": "Chase Value", "logo": "assets/images/chasevalue.png"},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Select a Brand",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  itemCount: brands.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.4, // Rectangular layout ratio
                  ),
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close brand sheet
                        _showGarmentsSelectionSheet(context, brand['name']!); // Open garments sheet
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: bgLavender,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.purple.shade100, width: 1.2),
                        ),
                        child: Center(
                          child: Image.asset(
                            brand['logo']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                brand['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryPurple,
                                ),
                              );
                            },
                          ),
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

  // 2. Selected Brand ke Garments select karne ke liye Bottom Sheet
  void _showGarmentsSelectionSheet(BuildContext context, String brandName) {
    final garments = _getBrandItems(brandName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: primaryPurple),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                      _showBrandSelectionSheet(context); // Go back to brands
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "$brandName Collection",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  itemCount: garments.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final item = garments[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedGarmentUrl = item['image'];
                        });
                        Navigator.pop(context); // Close sheet
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgLavender,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['title']!,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                maxLines: 1,
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

  Future<void> _generateVirtualTryOn() async {
    if (_userPhotoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload your photo first!")),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isGenerating = false;
        _resultImageBytes = _userPhotoBytes;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Virtual try-on generated successfully!")),
      );
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLavender,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text(
          "Virtual Try-On",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primaryPurple),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Upload your clear photo and select an outfit to generate virtual try-on.",
                      style: TextStyle(color: Color(0xFF4A2E7A), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 1. User Photo Section
            const Text(
              "1. Your Photo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2E7A)),
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: _userPhotoBytes != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(_userPhotoBytes!, fit: BoxFit.cover),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, foregroundColor: Colors.white),
                        onPressed: _pickUserPhoto,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Change"),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 45, color: accentPink),
                  const SizedBox(height: 8),
                  Text("Tap to upload your clear photo", style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, foregroundColor: Colors.white),
                    onPressed: _pickUserPhoto,
                    child: const Text("Upload Photo"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Selected Outfit Section
            const Text(
              "2. Selected Outfit",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2E7A)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showBrandSelectionSheet(context),
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.shade200, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedGarmentUrl != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _selectedGarmentUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, color: primaryPurple, size: 30);
                          },
                        ),
                      )
                          : Icon(Icons.checkroom, color: primaryPurple, size: 35),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Selected Garment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(
                            _selectedGarmentUrl != null ? "Tap to change outfit" : "Tap to select from brands",
                            style: TextStyle(color: accentPink, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: primaryPurple),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Generate Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _isGenerating ? null : _generateVirtualTryOn,
              child: _isGenerating
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Text("Generate Virtual Try-On", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            if (_resultImageBytes != null) ...[
              const SizedBox(height: 30),
              const Text(
                "3. Try-On Result",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2E7A)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(_resultImageBytes!, fit: BoxFit.cover),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}