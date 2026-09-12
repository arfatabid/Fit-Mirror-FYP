import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/gemini_service.dart';
import '../../services/database_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late GeminiService _geminiService;
  final DatabaseService _dbService = DatabaseService();
  bool _isTyping = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initGemini();
  }

  Future<void> _initGemini() async {
    _geminiService = GeminiService();
    setState(() {
      _isLoaded = true;
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Check if user is logged in
    final user = _dbService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to chat with the stylist")),
      );
      return;
    }

    _controller.clear();
    setState(() => _isTyping = true);

    // Save user message to Firestore
    await _dbService.saveChatMessage(text, 'user');

    // Get response from Gemini
    final response = await _geminiService.getResponse(text);

    // Save bot response to Firestore
    await _dbService.saveChatMessage(response, 'bot');

    setState(() => _isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF5E35B1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Fashion Stylist", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: Column(
          children: [
            Expanded(
              child: !_isLoaded
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _dbService.getChatMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 80, color: primaryPurple.withOpacity(0.2)),
                                const SizedBox(height: 20),
                                Text(
                                  "Hello! I'm your AI Fashion Stylist.",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple),
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    "Ask me about outfit ideas, color matching, or what to wear for any occasion!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final messages = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        reverse: true, // Show latest messages at bottom
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msgData = messages[index].data() as Map<String, dynamic>;
                          final text = msgData['text'] ?? '';
                          final isUser = msgData['role'] == 'user';
                          return _buildMessageBubble(text, isUser);
                        },
                      );
                    },
                  ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: primaryPurple),
                    ),
                    const SizedBox(width: 8),
                    const Text("Stylist is thinking...", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ),
              ),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    final Color primaryPurple = const Color(0xFF5E35B1);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? primaryPurple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    final Color primaryPurple = const Color(0xFF5E35B1);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ask about outfit ideas...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: primaryPurple,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
