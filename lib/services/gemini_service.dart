import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  GenerativeModel? _model;
  ChatSession? _chat;

  GeminiService() {
    _initialize();
  }

  void _initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      print("Error: GEMINI_API_KEY is missing in .env file");
      return;
    }

    try {
      _model = GenerativeModel(
        model: 'gemini-3.5-flash-lite',
        apiKey: apiKey,
        systemInstruction: Content.system(
          'You are the Fit Mirror AI Fashion Assistant. '
          'Your goal is to help users with styling advice, outfit ideas, and color combinations. '
          'You should be friendly, trendy, and knowledgeable about fashion. '
          'If asked about the Fit Mirror app, you can explain that it is a virtual try-on platform '
          'that uses AI to help users visualize clothes on themselves.'
        ),
      );
      _chat = _model?.startChat();
    } catch (e) {
      print("Error initializing Gemini: $e");
    }
  }

  Future<String> getResponse(String message) async {
    if (_model == null || _chat == null) {
      return "AI Stylist is not configured. Please check your API key in the .env file.";
    }

    try {
      final response = await _chat?.sendMessage(Content.text(message));
      return response?.text ?? 'Sorry, I could not generate a response.';
    } catch (e) {
      if (e.toString().contains("403") || e.toString().contains("401")) {
        return "Invalid API Key. Please update your .env file with a valid Gemini API key.";
      }
      return 'Error: ${e.toString()}';
    }
  }

  void resetChat() {
    if (_model != null) {
      _chat = _model?.startChat();
    }
  }
}
