import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIAPI {
// singleton
  OpenAIAPI._privateConstructor();

  static final OpenAIAPI instance = OpenAIAPI._privateConstructor();

  // curl https://api.openai.com/v1/chat/completions \                                                                          
  // -H "Content-Type: application/json" \
  // -H "Authorization: Bearer $OPENAI_API_KEY" \
  // -d '{
  //   "model": "gpt-3.5-turbo",
  //   "messages": [{"role": "user", "content": "使用flutter编写使用openai"}]      
  // }'
  static Future<String> sendMessage(String message) async {
    final String apiUrl =
        'https://api.openai.com/v1/chat/completions';
    const String apiKey = "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";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': message}
          ],
        },
      ),
    );
    return response.body;
  }

// {"id":"chatcmpl-6vMsnlpaFhEtnYw2CDr6tM7uHmKpo","object":"chat.completion","created":1679130677,"model":"gpt-3.5-turbo-0301","usage":{"prompt_tokens":16,"completion_tokens":1129,"total_tokens":1145},"choices":[{"message":{"role":"assistant","content":"\n\n作为AI领域的佼佼者，OpenAI提供了一系列的AI模型和API，让我们可以快速实现各种智能应用。在这篇文章中，我们将介绍如何使用flutter调用OpenAI的API，以实现自然语言处理和AI问答等功能。\n\n1.注册OpenAI API\n\n首先，我们需要去OpenAI官网注册并获取API密钥。目前OpenAI仅提供有限的API Token，需要进行申请。\n\n2.创建Flutter项目\n\n创建一个新的Flutter项目，并添加http依赖来进行网络请求。\n\n3.编写API请求代码\n\n在Flutter中使用OpenAI API，我们需要发送HTTP请求，包含API密钥和请求参数。下面是一个简单的代码示例：\n\n```\nimport 'dart:convert';\nimport 'package:http/http.dart' as http;\n \nFuture<String> sendMessage(String message) async {\n  final String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';\n  final String apiKey = 'INSERT_YOUR_API_KEY_HERE';\n  final response = await http.post(\n    Uri.parse(apiUrl),\n    headers: <String, String>{\n      'Content-Type': 'application/json',\n      'Authorization': 'Bearer $apiKey',\n    },\n    body: jsonEncode(\n      <String, dynamic>{\n        'prompt': message,\n        'max_tokens': 100,\n        'temperature': 0.5,\n      },\n    ),\n  );\n  return response.body;\n}\n```\n\n在上面的代码中，我们使用http.post方法发送一个POST请求，携带API密钥和请求参数。请求的地址为OpenAI的API地址，我们需要将其替换成自己的API URL。请求参数包含 prompt（输入的文本）、max_tokens（生成文本的最大长度）和temperature（生成文本的随机程度）。\n\n4.处理API响应\n\n接下来，我们需要处理API的响应结果。OpenAI返回一个JSON格式的响应，我们可以使用Dart的jsonDecode方法将其解码。下面是一个简单的示例：\n\n```\nFuture<String> sendMessage(String message) async {\n  // ...\n  final response = await http.post(...);\n  final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;\n  final generatedText = jsonResponse['choices'][0]['text'].toString();\n  return generatedText;\n}\n```\n\n在这个代码中，我们将API响应的body解码成一个Map对象，然后获取生成的文本。\n\n5.使用Flutter应用\n\n最后一步就是将OpenAI API和Flutter应用结合起来了。我们可以在Flutter应用中使用该API来完成各种智能功能，如聊天机器人、语言翻译、问答等。下面是一个简单的示例：\n\n```\nimport 'package:flutter/material.dart';\nimport 'package:openai_flutter/openai_flutter.dart';\n \nvoid main() => runApp(MyApp());\n \nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'OpenAI Flutter Demo',\n      home: ChatScreen(),\n    );\n  }\n}\n \nclass ChatScreen extends StatefulWidget {\n  @override\n  _ChatScreenState createState() => _ChatScreenState();\n}\n \nclass _ChatScreenState extends State<ChatScreen> {\n  final textController = TextEditingController();\n  final messages = <String>[];\n \n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(title: Text('Chat Bot')),\n      body: Column(\n        children: [\n          Flexible(\n            child: ListView.builder(\n              itemCount: messages.length,\n              itemBuilder: (_, index) => ListTile(title: Text(messages[index])),\n            ),\n          ),\n          TextField(\n            controller: textController,\n            decoration: InputDecoration(hintText: 'Type a message...'),\n            onSubmitted: (_) => sendMessage(),\n          ),\n        ],\n      ),\n    );\n  }\n \n  Future<void> sendMessage() async {\n    final message = textController.text;\n    if (message.isNotEmpty) {\n      // send message to openai api\n      final response = await OpenAIAPI.sendMessage(message);\n      // add response to messages list\n      setState(() => messages.addAll([message, response]));\n      // clear text field\n      textController.text = '';\n    }\n  }\n}\n```\n\n在这个例子中，我们创建了一个简单的聊天机器人，在用户输入消息后，将其发送到OpenAI API并获取回复，然后将对话添加到屏幕上。OpenAI的API调用使用了OpenAIAPI.sendMessage，我们需要将其替换成我们自己的API调用方法。\n\n到此为止，我们已经完成了一个使用Flutter调用OpenAI API的例子。使用OpenAI API，我们可以快速、简单地实现各种智能功能，为应用程序增加更多的价值。"},"finish_reason":"stop","index":0}]}
  static Future<String> parse(String content) async {
    final jsonResponse = jsonDecode(content) as Map<String, dynamic>;
    final generatedText = jsonResponse['choices'][0]['message'].toString();
    return generatedText;
  }
}
