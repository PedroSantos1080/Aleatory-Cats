import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consumindo_api/app/data/http/http_client.dart';
import 'package:consumindo_api/app/data/repositories/cat_repository.dart';
import 'package:consumindo_api/app/data/constants/constants.dart';
import 'package:consumindo_api/app/pages/home/stores/cat_store.dart';

import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];

  void sendMessage(String message) async {
    // Armazene todas as mensagens da conversa em uma lista
    List<Map<String, String>> conversation = [
      {
        "role": "system",
        "content":
            "Você é um gerador de nome e descrição a aleatórios para gatos"
      },
      {"role": "user", "content": message}
    ];

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.apiKeyOpenAi}',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": conversation, // Use a lista de mensagens aqui
        "temperature": 0.7,
        "max_tokens": 200, // Limita o comprimento da resposta
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        //chatMessages.add(ChatMessage(text: message, isUser: true));
        chatMessages.add(ChatMessage(
            text: jsonResponse['choices'][0]["message"]["content"],
            isUser: false));
      });
    } else {
      // ignore: avoid_print
      print("Falha no request: ${response.statusCode}");
      // ignore: avoid_print
      print("Falha no request: ${utf8.decode(response.bodyBytes)}");
    }
  }

  String catId = '';

  final CatStore store = CatStore(
    repository: CatRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 160, 122),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: RichText(
          text: const TextSpan(
            children: [
              WidgetSpan(
                child: Image(
                  image: AssetImage("assets/pata.png"),
                ),
              ),
              TextSpan(
                  text: "Aleatory Cats",
                  style: TextStyle(
                    fontSize: 26,
                  )),
              WidgetSpan(
                child: Image(
                  image: AssetImage("assets/gato_icon.png"),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fundo_cats.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            store.isLoad,
            store.erro,
            store.state,
          ]),
          builder: (context, child) {
            if (store.isLoad.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (store.erro.value.isNotEmpty) {
              return Center(
                child: Text(
                  store.erro.value,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (store.state.value.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum item na lista.',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 32,
                      ),
                  padding: const EdgeInsets.all(16),
                  itemCount: store.state.value.length,
                  itemBuilder: (_, index) {
                    final item = store.state.value[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 10,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0))),
                            child: Image.network(
                              width: 350,
                              height: 350,
                              item.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        // ignore: unused_local_variable
                                        sendMessage(
                                            "Me dê um nome aleatório, um genêro(macho ou fêmea), uma idade e uma descrição breve sobre um gato ou uma gata, sem descrever sua aparência, apenas uma personalidade.");
                                        chatMessages.clear();
                                        // ignore: unused_local_variable
                                        await store.getCats();
                                      } catch (e) {
                                        const Text("erro");
                                      }
                                    },
                                    child: const Text("Próximo gatinho ->")),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: chatMessages.length,
                                itemBuilder: (context, index) {
                                  final message = chatMessages[index];
                                  return ChatBubble(
                                    text: message.text,
                                  );
                                }),
                          ],
                        ),
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;

  const ChatBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 196, 170),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: Text(
        text,
        style:
            const TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
