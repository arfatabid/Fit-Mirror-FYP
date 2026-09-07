import 'package:flutter/material.dart';
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

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  final Color primaryPurple = const Color(0xFF5E35B1);
  final Color accentPink = const Color(0xFFE91E63);

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
      });
    }
  }

  // 2. RapidAPI Try-On Diffusion API Integration
  Future<void> _startRapidApiTryOn() async {
    if (_userPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your photo first! (Business Rule)"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

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
                  ),
                ),
                const SizedBox(height: 15),

                // Display Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentPink.withOpacity(0.3)),
                    ),
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
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

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
        ),
      ),
    );
  }
}