import 'package:flutter/material.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: text, sender: 'user'));
      // Simulate a bot response
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.insert(0, ChatMessage(text: 'Echo: $text', sender: 'bot'));
        });
      });
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                final isUserMessage = message.sender == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: <Widget>[
                      if (!isUserMessage)
                        const CircleAvatar(child: Text('B')),
                      if (!isUserMessage)
                        const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(isUserMessage ? 'You' : 'Bot', style: Theme.of(context).textTheme.titleSmall),
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(message.text),
                            ),
                          ],
                        ),
                      ),
                      if (isUserMessage)
                        const SizedBox(width: 8.0),
                      if (isUserMessage)
                        const CircleAvatar(child: Text('U')),
                    ],
                  ),
                );
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
