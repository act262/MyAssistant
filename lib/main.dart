import 'package:flutter/material.dart';
import 'openai_api.dart';
import 'package:dart_openai/openai.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OpenAI.apiKey = "xxoo";

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
      appBar: AppBar(
        title: Text('Chat Bot'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => ListTile(title: Text(messages[index])),
            ),
          ),
          const Divider(height: 2),
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
      try {
        debugPrint("chat created");
        OpenAIChatCompletionModel chatCompletion =
            await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: [
            OpenAIChatCompletionChoiceMessageModel(
                role: "system", content: "You are a helpful assistant."),
            OpenAIChatCompletionChoiceMessageModel(
                content: message, role: "user"),
          ],
        );

        print(chatCompletion.choices.first.message.content);

        // add response to messages list
        setState(() => messages
            .addAll([message, chatCompletion.choices.first.message.content]));
        // clear text field
        textController.text = '';
      } on RequestFailedException catch (e) {
        print(e);
      }
    }
  }
}
