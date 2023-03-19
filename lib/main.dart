import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:dart_openai/openai.dart';

import 'env/env.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OpenAI.apiKey = Env.apiKey;

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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Bot'),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: _clickMenu,
            ),
          ],
        ),
        body: Column(children: [
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => Container(
                color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                child: ListTile(title: _buildMessage(messages[index])),
              ),
            ),
          ),
          const Divider(height: 2),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                ),
              ],
            ),
          )
        ]));
  }

  void _clickMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000.0, 75.0, 0.0, 0.0), //让菜单显示在AppBar的右侧
      items: <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'value1',
          child: Text('Menu item 1'),
        ),
        PopupMenuItem<String>(
          value: 'value2',
          child: Text('Menu item 2'),
        ),
      ],
    ).then((value) {
      // 处理弹出菜单选择的值
    });
  }

  Future<void> _sendMessage() async {
    final message = textController.text;
    if (message.isNotEmpty) {
      // send message to openai api
      try {
        debugPrint("chat created");
        setState(() => _isLoading = true);
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
        setState(() => _isLoading = false);
        // clear text field
        textController.text = '';
      } on RequestFailedException catch (e) {
        print(e);
        // 提示错误信息
        setState(() => _isLoading = false);
        // show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 显示文本内容的代码块内容
  Widget _buildMessage(String message) {
    var regex = RegExp(r'^```(\w*)\n([\s\S]*?)\n```$');
    // var matches = regex.allMatches(message);
    // matches.forEach((match) {
    //   var language = match.group(1);
    //   var code = match.group(2);
    //   // return _buildCodeBlock(language, code);
    // });

    var match = regex.firstMatch(message);
    if (match == null) {
      return Text(message);
    }
    String language = match[1]!;
    String code = match[2]!;

    return _buildCodeBlock(language, code);
  }

  Widget _buildCodeBlock(String? language, String code) {
    return HighlightView(
      // The original code to be highlighted
      code,

      // Specify language
      // It is recommended to give it a value for performance
      language: language,

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: githubTheme,

      // Specify padding
      padding: EdgeInsets.all(12),

      // Specify text style
      textStyle: TextStyle(
        fontFamily: 'My awesome monospace font',
        fontSize: 16,
      ),
    );
  }
}
