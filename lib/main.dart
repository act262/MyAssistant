import 'package:flutter/material.dart';
import 'openai_api.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OpenAI Flutter Demo',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final messages = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Bot')),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => ListTile(title: Text(messages[index])),
            ),
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Type a message...'),
            onSubmitted: (_) => sendMessage(),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    final message = textController.text;
    if (message.isNotEmpty) {
      // send message to openai api
      final response = await OpenAIAPI.sendMessage(message);
      final text = await OpenAIAPI.parse(response);
      // add response to messages list
      setState(() => messages.addAll([message, text]));
      // clear text field
      textController.text = '';
    }
  }
}
