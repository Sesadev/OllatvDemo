


import 'package:ollatv/app/ui/custom_appbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:intl/intl.dart'; // For formatting timestamps
import 'dart:convert'; // For encoding and decoding JSON
import 'package:path_provider/path_provider.dart'; // To access file system
import 'dart:io'; // For working with files

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // To store messages
  ably.Realtime? _realtimeInstance;
  ably.RealtimeChannel? _channel;

  String? _userId;
  String? _receiverId; // Store receiver's ID for unique key

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createAblyRealtimeInstance();
    });
  }

  @override
  void dispose() {
    _realtimeInstance?.connection.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Create Ably Realtime instance
  void _createAblyRealtimeInstance() async {
    _realtimeInstance = ably.Realtime(key: 'SdvItQ.QLYPyA:NzxN7xqKWk9mNTCBmTWSZbNqukhE5x8F6-RlDNbVcvQ');
    _realtimeInstance!.connection.on(ably.ConnectionEvent.connected).listen((ably.ConnectionStateChange stateChange) async {
      if (stateChange.current == ably.ConnectionState.connected) {
        _channel = _realtimeInstance!.channels.get('get-started');
        _channel!.subscribe().listen((message) {
          if (message.data is Map<Object?, Object?>) {
            final Map<String, dynamic> messageData = Map<String, dynamic>.from(message.data as Map);

            // Check if the message is not from the current user
            if (messageData['sender'] != _userId) {
              _addMessage(messageData['message'], false);
            }
          }
        });

        // Load chat from JSON file if it exists
        await _loadChatFromFile();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    try {
      await _channel?.publish(name: 'chat-message', data: {
        'message': _controller.text,
        'sender': _userId,
      });

      _addMessage(_controller.text, true);
      _controller.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  // Add message to the list and save to file
  void _addMessage(String message, bool sentByMe) {
    setState(() {
      _messages.add({
        'message': message,
        'sent': sentByMe,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });

    _scrollToBottom();

    // Save the message to the JSON file
    _saveChatToFile();
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Save chat history to JSON file
  Future<void> _saveChatToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chat_history.json');
    final String key = _generateChatKey();

    // Read existing chat history or create a new one
    Map<String, dynamic> chatHistory = {};
    if (await file.exists()) {
      chatHistory = json.decode(await file.readAsString());
    }

    // Save the chat under the generated key
    chatHistory[key] = _messages;

    // Write the updated chat history to the file
    await file.writeAsString(json.encode(chatHistory));
  }

  // Load chat history from JSON file
  Future<void> _loadChatFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chat_history.json');
    final String key = _generateChatKey();

    if (await file.exists()) {
      final chatHistory = json.decode(await file.readAsString());
      if (chatHistory[key] != null) {
        // Populate the messages from the JSON file
        setState(() {
          _messages.addAll(List<Map<String, dynamic>>.from(chatHistory[key]));
        });
      }
    }
  }

  // Generate unique key for chat between sender and receiver
  String _generateChatKey() {
    return '${_userId}_$_receiverId'; // Key format: sender_receiver
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _userId = args['userId'];
    final String contactName = args['contactName'];
    _receiverId = contactName; // Use contactName as receiverId for simplicity

    return Scaffold(
      appBar: CustomAppBar(
        title: "Chat with $contactName",
        showBackButton: true,
      ),
      backgroundColor: Colors.grey[200],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['message'],
                  message['sent'],
                  DateTime.parse(message['timestamp']),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // Widget to build chat input area with TextField and Send button
  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build a chat message bubble
  Widget _buildMessageBubble(String message, bool sentByMe, DateTime timestamp) {
    final alignment = sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = sentByMe ? Colors.green[100] : Colors.grey[300];
    final textColor = sentByMe ? Colors.black : Colors.black;
    final borderRadius = sentByMe
        ? BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );
    final formattedTime = DateFormat('HH:mm').format(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(
                message,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                formattedTime,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
