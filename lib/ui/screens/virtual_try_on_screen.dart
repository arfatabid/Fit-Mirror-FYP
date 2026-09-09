import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VirtualTryOnScreen extends StatefulWidget {
  final String itemTitle;
  final String itemImagePath;

  const VirtualTryOnScreen({
    super.key,
    required this.itemTitle,
    required this.itemImagePath,
  });
=======
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class VirtualTryOnScreen extends StatefulWidget {
  final String? garmentImageUrl; // Catalog se selected outfit asset path pass karne ke liye
  const VirtualTryOnScreen({super.key, this.garmentImageUrl});
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

<<<<<<< HEAD
  File? _userPhoto;
  bool _isLoading = false;
  String? _resultImageUrl;

  // 1. Pick user photo from gallery
  Future<void> _pickUserPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _userPhoto = File(pickedFile.path);
        _resultImageUrl = null;
=======
  bool _isGenerating = false;
  Uint8List? _userPhotoBytes;
  Uint8List? _resultImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickUserPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _userPhotoBytes = bytes;
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
      });
    }
  }

<<<<<<< HEAD
  // 2. RapidAPI Try-On Diffusion API Integration
  Future<void> _startRapidApiTryOn() async {
    if (_userPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your photo first! (Business Rule)"),
          backgroundColor: Colors.redAccent,
        ),
=======
  Future<void> _generateVirtualTryOn() async {
    if (_userPhotoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload your photo first!")),
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
      );
      return;
    }

<<<<<<< HEAD
    setState(() {
      _isLoading = true;
    });

    try {
      // RapidAPI endpoint (Aap jo bhi RapidAPI use kar rahe hain uska URL yahan dein)
      var uri = Uri.parse("https://YOUR_RAPID_API_ENDPOINT_URL");
      var request = http.MultipartRequest('POST', uri);

      // RapidAPI Required Headers
      request.headers['X-RapidAPI-Key'] = 'YOUR_RAPID_API_KEY';
      request.headers['X-RapidAPI-Host'] = 'YOUR_RAPID_API_HOST';

      // Attach User Photo
      request.files.add(
        await http.MultipartFile.fromPath('person_image', _userPhoto!.path),
      );

      // Garment Image (Asset image ko temporary file bana kar ya path ke zariye bhejna)
      // Note: Agar asset image direct file path nahi leti, toh usay bytes mein convert karna par sakta hai.
      request.fields['garment_image'] = widget.itemImagePath;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          // API ke response format ke mutabiq image key set karein (e.g., output, image_url)
          _resultImageUrl = data['output'] ?? data['image_url'];
          _isLoading = false;
        });
      } else {
        throw Exception("Server didn't respond. Try again.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Try again. Server didn't respond."),
          backgroundColor: Colors.redAccent,
        ),
=======
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
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
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
        title: Text(
          "Virtual Try-On",
          style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primaryPurple),
      ),
<<<<<<< HEAD
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Selected Outfit Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.itemImagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Selected Outfit", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              widget.itemTitle,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryPurple),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
=======
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
                  ),
                ),
                const SizedBox(height: 15),

<<<<<<< HEAD
                // Display Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
=======
            // 2. Selected Outfit Section
            const Text(
              "2. Selected Outfit",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A2E7A)),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 80,
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentPink.withOpacity(0.3)),
                    ),
<<<<<<< HEAD
                    child: _isLoading
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: accentPink),
                          const SizedBox(height: 15),
                          Text(
                            "Connecting to RapidAPI Diffusion Model...\nPlease Wait",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryPurple, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                        : _resultImageUrl != null
                        ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green, size: 22),
                            SizedBox(width: 6),
                            Text("Try-On Generated Successfully!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(_resultImageUrl!, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _userPhoto == null
                            ? Column(
                          children: [
                            Icon(Icons.person_add_alt_1, size: 60, color: accentPink),
                            const SizedBox(height: 10),
                            const Text("Upload Clear Photo (Business Rule)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        )
                            : Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(_userPhoto!, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: _pickUserPhoto,
                          icon: const Icon(Icons.upload, size: 18),
                          label: Text(_userPhoto == null ? "Upload Your Photo" : "Change Photo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
=======
                    child: widget.garmentImageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.garmentImageUrl!,
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
                          widget.garmentImageUrl != null ? "Outfit from catalog" : "Default catalog item",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

<<<<<<< HEAD
                // Trigger Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _startRapidApiTryOn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Generate Virtual Try-On", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
=======
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
>>>>>>> e3c06d9418938a5d1bad884d60dea6e1ee03b485
        ),
      ),
    );
  }
}