import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import '../../services/database_service.dart';

class VirtualTryOnScreen extends StatefulWidget {
  final String? garmentImageUrl; // slected path in catalogue
  const VirtualTryOnScreen({super.key, this.garmentImageUrl});

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

  File? _userPhoto;
  bool _isLoading = false;
  Uint8List? _resultImageBytes;

  // Locally selected garment manage karne ke liye taake user try-on screen se hi change kar sakay
  String? _selectedGarmentUrl;

  @override
  void initState() {
    super.initState();
    _selectedGarmentUrl = widget.garmentImageUrl;
  }

  Future<void> _pickUserPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _userPhoto = File(pickedFile.path);
        _resultImageBytes = null;
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
        "Black CasualShirt Men.png",
        "Black WaisCoat Men.png",
        "Blue kurti Women.png",
        "Blue Long Suite Women.png",
        "Blue WaisCoat Men.png",
        "Cream CasualShirt Men.png",
        "Cream Kurta Men.png",
        "Dark Kurta Men.png",
        "Green Suite Women.png",
        "light Green CasualShirt Men.png",
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
    } else if (brandName == "Breakout") {
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
        "Grey tees women.png",
        "Grey SweatShirt Men.png",
        "Mehroon Top Women.png",
        "Navy SweatShirt Women.png",
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
    } else if (brandName == "Outfitters") {
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
    } else if (brandName == "ChaseValue") {
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
      {"name": "ChaseValue", "logo": "assets/images/chasevalue.png"},
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
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
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
                          color: Colors.purple.shade50,
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
    if (_userPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your photo first!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedGarmentUrl == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an item from the catalog first!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // RapidAPI endpoint
      final endpoint = dotenv.env['RAPID_API_ENDPOINT_URL'] ?? '';
      final apiKey = dotenv.env['RAPID_API_KEY'] ?? '';
      final apiHost = dotenv.env['RAPID_API_HOST'] ?? '';

      var uri = Uri.parse("https://$endpoint");
      var request = http.MultipartRequest('POST', uri);

      // RapidAPI Required Headers
      request.headers['X-RapidAPI-Key'] = apiKey;
      request.headers['X-RapidAPI-Host'] = apiHost;

      // Attach User Photo (Avatar Image)
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar_image', 
          _userPhoto!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Load Garment Image from assets and attach (Clothing Image)
      ByteData garmentByteData = await rootBundle.load(_selectedGarmentUrl!);
      List<int> garmentBytes = garmentByteData.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes(
          'clothing_image',
          garmentBytes,
          filename: 'garment.png',
          contentType: MediaType('image', 'png'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // The API returns the raw image bytes directly
        if (!mounted) return;
        setState(() {
          _resultImageBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        throw Exception("Server Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Virtual Try-On",
          style: TextStyle(color: Color(0xFF5E35B1), fontWeight: FontWeight.bold),
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

            // 1. Your Photo Section
            const Text(
              "1. Your Photo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2E7A)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickUserPhoto,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.shade200, width: 1.5),
                ),
                child: _userPhoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_userPhoto!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: primaryPurple, size: 40),
                          const SizedBox(height: 8),
                          Text("Tap to upload photo", style: TextStyle(color: primaryPurple, fontWeight: FontWeight.w500)),
                        ],
                      ),
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
                    if (_selectedGarmentUrl != null)
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: accentPink),
                        onPressed: () async {
                          final name = _selectedGarmentUrl!.split('/').last.replaceAll('.png', '');
                          await DatabaseService().addToWardrobe(name: name, imagePath: _selectedGarmentUrl!);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Garment saved to Wardrobe!"),
                              backgroundColor: accentPink,
                            ),
                          );
                        },
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
              onPressed: _isLoading ? null : _generateVirtualTryOn,
              child: _isLoading
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
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    _resultImageBytes!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ], // closes if (_resultImageBytes != null) ...[
          ], // closes children: [
        ), // closes Column(
      ), // closes SingleChildScrollView(
    ); // closes Scaffold(
  }
}
