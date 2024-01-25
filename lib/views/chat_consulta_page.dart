import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/chat_controller.dart';
import '../models/message_model.dart';
import '../utils/class/Theme.dart';

class ChatConsultaPage extends StatefulWidget {
  const ChatConsultaPage(
      {required this.userId,
      required this.receiverId,
      required this.receiverName,
      required this.userToken,
      required this.tipo,
      required this.nome,
      Key? key})
      : super(key: key);
  final int userId;
  final int receiverId;
  final String receiverName;
  final String userToken;
  final String tipo;
  final String nome;

  @override
  State<ChatConsultaPage> createState() => _ChatConsultaPageState();
}

class _ChatConsultaPageState extends State<ChatConsultaPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];

  Map<String, dynamic> mensagensSalvas = {};

  late int userId;
  late int receiverId;
  late String receiverName;
  late String userToken;
  late String tipo;
  late String nome;

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    receiverId = widget.receiverId;
    userToken = widget.userToken;
    tipo = widget.tipo;
    nome = widget.nome;
    receiverName = widget.receiverName;
    print('sender: ${userId}_$nome');
    print('Receiver: ${receiverId}_$receiverName');

    _loadConversas(userToken);
    initSocket();
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void initSocket() {
    socket = IO.io('ws://192.168.1.23:3000', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'auth': {'token': userToken},
    });

    socket.connect();

    socket.onConnect((_) {
      print('Conexão estabelecida: ${socket.id} (UserID: $userId)');
    });

    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    socket.on('getMessageEvent', (data) {
      if (mounted) {
        setState(() {
          _messages.add(Message(data['text'].toString(),
              data['sender'].toString(), data['receiver'].toString()));
        });
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _sendMessage(String text, String receiver) {
    if (text.isNotEmpty && receiver.isNotEmpty) {
      // Envia a mensagem para o servidor
      socket.emit('sendMessageEvent',
          {'text': text, 'receiver': '${receiverId}_$receiverName'});
      _textController.clear();
    }
  }

  Future<void> _loadConversas(String userToken) async {
    _setLoading(true);
    Map<String, dynamic> fetchMensagensSalvas = await getMensagensConsulta(userToken);

    setState(() {
      mensagensSalvas = fetchMensagensSalvas;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    _setLoading(false);
    print("maxScrollExtent: ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(position);
    }
    print("maxScrollExtent: ${_scrollController.position.maxScrollExtent}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Card(
                shape: CircleBorder(side: BorderSide(color: Colors.black)),
                child: Icon(Icons.person, size: 45.0),
              ),
              Text(receiverName),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              socket.disconnect();
              socket.onDisconnect((_) {
                print('Desconectado do Socket.IO');
              });
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            (_isLoading == true)
                ? const Center(child: CircularProgressIndicator())
                : _chatBuild()
          ],
        ),
      ),
    );
  }

  Widget _chatBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: mensagensSalvas['mensagens'].length + _messages.length,
              itemBuilder: (context, index) {
                if (index < mensagensSalvas['mensagens'].length) {
                  // Construa o item da mensagem salva
                  bool isMyMessage = mensagensSalvas['mensagens'][index]
                          ['sender'] ==
                      '${userId}_$nome';

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isMyMessage ? 0.0 : 18.0,
                      right: isMyMessage ? 18.0 : 0.0,
                      top: 8.0,
                      bottom: 0.0,
                    ),
                    child: Row(
                      mainAxisAlignment: isMyMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      mensagensSalvas['mensagens'][index]
                                          ['text'],
                                    ),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.done),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Construa o item da mensagem normal
                  int normalIndex =
                      (index - mensagensSalvas['mensagens'].length).toInt();
                  bool isMyMessage = _messages[normalIndex].sender == nome;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isMyMessage ? 0.0 : 18.0,
                      right: isMyMessage ? 18.0 : 0.0,
                      top: 8.0,
                      bottom: 0.0,
                    ),
                    child: Row(
                      mainAxisAlignment: isMyMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      _messages[normalIndex].text,
                                    ),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.done),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua mensagem...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_textController.text, receiverId.toString());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
