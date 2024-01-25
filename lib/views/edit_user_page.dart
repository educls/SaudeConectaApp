import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../controllers/patient_controller.dart';
import '../utils/class/Theme.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({required this.userInfos, required this.userToken, Key? key})
      : super(key: key);
  Map<String, dynamic> userInfos;
  final String userToken;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  Map<String, dynamic> userInfos = {};
  Map<String, dynamic> userInfosEndereco = {};
  late String userToken;

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  final TextEditingController _status = TextEditingController();

  final TextEditingController _estado = TextEditingController();
  final TextEditingController _cidade = TextEditingController();
  final TextEditingController _bairro = TextEditingController();
  final TextEditingController _rua = TextEditingController();
  final TextEditingController _numero = TextEditingController();

  @override
  void initState() {
    super.initState();

    userInfos = widget.userInfos;
    userToken = widget.userToken;
    _setInfos();
    _buscarEndereco();

    print(userInfos);
  }

  void _setInfos() {
    _setLoading(true);

    _nome.text = userInfos['usuarioInfos']['Nome'];
    _email.text = userInfos['usuarioInfos']['Email'];
    _password.text = userInfos['usuarioInfos']['Senha'];
    _cpf.text = userInfos['usuarioInfos']['CPF'];
    _telefone.text = userInfos['usuarioInfos']['Telefone'];
    _status.text = userInfos['usuarioInfos']['Status'];
  }

  void _setEndereco(userInfosEndereco) async {
    _estado.text = userInfosEndereco['usuarioInfosEndereco']['Estado'];
    _cidade.text = userInfosEndereco['usuarioInfosEndereco']['Cidade'];
    _bairro.text = userInfosEndereco['usuarioInfosEndereco']['Bairro'];
    _rua.text = userInfosEndereco['usuarioInfosEndereco']['Rua'];
    _numero.text = userInfosEndereco['usuarioInfosEndereco']['Numero'];

    await Future.delayed(const Duration(milliseconds: 500));
    _setLoading(false);
  }

  Future<void> _buscarEndereco() async {
    userInfosEndereco = await getInfosUserEndereco(userToken);
    print(userInfosEndereco);

    _setEndereco(userInfosEndereco);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Informações"),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
              ? const Center(child: CircularProgressIndicator())
              : (userInfos == null ||
                      userInfos['usuarioInfos'] == null ||
                      userInfos['usuarioInfos'].isEmpty)
                  ? const Center(child: Text("Nenhuma Informação Encontrada"))
                  : _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                    childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          enabled: false,
                          autofocus: _isLoading,
                          keyboardType: TextInputType.emailAddress,
                          controller: _nome,
                          decoration: const InputDecoration(
                            labelText: "Nome",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _password,
                          decoration: const InputDecoration(
                            labelText: "Senha",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: _cpf,
                          decoration: const InputDecoration(
                            labelText: "CPF",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _telefone,
                          decoration: const InputDecoration(
                            labelText: "Telefone",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: _status,
                          decoration: const InputDecoration(
                            labelText: "Status",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text("Endereço"),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _estado,
                          decoration: const InputDecoration(
                            labelText: "Estado",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _cidade,
                          decoration: const InputDecoration(
                            labelText: "Cidade",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _bairro,
                          decoration: const InputDecoration(
                            labelText: "Bairro",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _rua,
                          decoration: const InputDecoration(
                            labelText: "Rua",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _numero,
                          decoration: const InputDecoration(
                            labelText: "Numero",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          _setLoading(true);

                          String response = await atualizaCadastro(
                              userToken,
                              _password.text,
                              _telefone.text,
                              _estado.text,
                              _cidade.text,
                              _bairro.text,
                              _rua.text,
                              _numero.text);
                          await Future.delayed(const Duration(milliseconds: 600));
                          print(response);
                          if (response == '201') {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Cadastro Atualizado'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        _setLoading(false);
                                      },
                                      child: const Text('Fechar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Não foi possivel Atualizar Cadastro'),
                                    actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        _setLoading(false);
                                      },
                                      child: const Text('Fechar'),
                                    ),
                                  ],
                                  );
                                }
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(75, 57, 239, 1),
                            minimumSize: const Size(350, 50)),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
