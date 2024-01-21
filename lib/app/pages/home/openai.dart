// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// const apiKey = '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';

// void main() {
//   runApp(const MaterialApp(
//     home: ChatScreen(),
//   ));
// }

// class ChatMessage {
//   final String text;
//   final bool isUser;

//   ChatMessage({required this.text, required this.isUser});
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController messageController = TextEditingController();
//   List<ChatMessage> chatMessages = [];

// void sendMessage(String message) async {
//   // Armazene todas as mensagens da conversa em uma lista
//   List<Map<String, String>> conversation = [
//     {"role": "system", "content": "Você é um gerador de nomes e história para gatos em português brasileiro."},
//     {"role": "user", "content": message}
//   ];

//   final response = await http.post(
//     Uri.parse('https://api.openai.com/v1/chat/completions'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey',
//     },
//     body: json.encode({
//       "model": "gpt-3.5-turbo",
//       "messages": conversation, // Use a lista de mensagens aqui
//       "temperature": 0.7,
//       "max_tokens": 200, // Limita o comprimento da resposta
//     }),
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     setState(() {
//       chatMessages.add(ChatMessage(text: message, isUser: true));
//       chatMessages.add(ChatMessage(text: jsonResponse['choices'][0]["message"]["content"], isUser: false));
//     });
//   } else {
//     // ignore: avoid_print
//     print("Falha no request: ${response.statusCode}");
//     // ignore: avoid_print
//     print("Falha no request: ${response.body}");
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ChatGPT App"),
//       ),
//       // body: Column(
//       //   children: [
//       //     Expanded(
//       //         child: ListView.builder(
//       //             itemCount: chatMessages.length,
//       //             itemBuilder: (context, index) {
//       //               final message = chatMessages[index];
//       //               return ChatBubble(
//       //                 text: message.text,
//       //                 isUser: message.isUser,
//       //               );
//       //             })),
//       //     Padding(
//       //       padding: const EdgeInsets.all(8),
//       //       child: Row(
//       //         children: [
//       //           Expanded(
//       //               child: TextField(
//       //             controller: messageController,
//       //             decoration: const InputDecoration(
//       //               hintText: "Insira seu texto",
//       //             ),
//       //           )),
//       //           IconButton(
//       //               onPressed: () {
//       //                 //sendMessage(messageController.text);
//       //                 sendMessage("Crie um nome e uma história breve e curta para um gato ou uma gata.");
//       //                 messageController.clear();
//       //               },
//       //               icon: const Icon(Icons.send))
//       //         ],
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   const ChatBubble({super.key, required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     return isUser ?  Text(text) : const Text("");
//   }
// }











