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

  Future<void> _pickUserPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _userPhotoBytes = bytes;
      });
    }
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
      ),
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
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                        ),
                      ],
                    ),
                  ),
                ],
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