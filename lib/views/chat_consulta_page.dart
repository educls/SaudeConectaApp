import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/chat_controller.dart';
import '../models/message_model.dart';
import '../utils/class/Theme.dart';
import '../utils/date_formater.dart';

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

  DateFormatter dateFormatter = DateFormatter();

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    print('UserId: $userId');
    receiverId = widget.receiverId;
    print('ReceiverId: $receiverId');
    userToken = widget.userToken;
    print('Token: $userToken');
    tipo = widget.tipo;
    print('Tipo: $tipo');
    nome = widget.nome;
    print('Nome: $nome');
    receiverName = widget.receiverName;
    print('receiverNome: $receiverName');

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
      setState(() {
        _messages.add(Message(data['text'].toString(), data['sender'].toString(), data['receiver'].toString(), data['timestamp'].toString()));
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _sendMessage(String text, String idUsuario, String idReceiver) {
    if (text.isNotEmpty) {
      if(tipo == 'paciente'){
        socket.emit('sendMessageEvent',
          {'idChat': '$userId$receiverId', 'text': text, 'receiver': '${receiverId}_$receiverName'});
      }else{
        socket.emit('sendMessageEvent',
          {'idChat': '$receiverId$userId', 'text': text, 'receiver': '${receiverId}_$receiverName'});
      }
      
      _textController.clear();
    }
  }

  Future<void> _loadConversas(String userToken) async {
    _setLoading(true);
    String idMensagem;
    if(tipo == 'paciente'){
      idMensagem = '$userId$receiverId';
    }else{
      idMensagem = '$receiverId$userId';
    }
    Map<String, dynamic> fetchMensagensSalvas =
        await getMensagensConsulta(userToken, idMensagem);

    setState(() {
      mensagensSalvas = fetchMensagensSalvas;
      print(mensagensSalvas);
    });
    await Future.delayed(const Duration(milliseconds: 500));

    _setLoading(false);
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
              socket.off('getMessageEvent');
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
                  bool isMyMessage = mensagensSalvas['mensagens'][index]
                          ['Sender'] ==
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
                                    Text(
                                      mensagensSalvas['mensagens'][index]
                                          ['Conteudo'],
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      mensagensSalvas['mensagens'][index]['Time_Message'],
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    (isMyMessage)
                                    ? const Icon(Icons.done)
                                    : const Text('')
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
                                    Text(
                                      _messages[normalIndex].text,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      _messages[normalIndex].timestamp,
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    (isMyMessage)
                                      ? const Icon(Icons.done)
                                      : const Text('')
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
                  onTap: () {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_textController.text, userId.toString(), receiverId.toString());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
