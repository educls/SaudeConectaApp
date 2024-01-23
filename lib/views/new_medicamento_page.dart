import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medicamento_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../utils/class/Theme.dart';
import '../utils/date_formater.dart';

class NewMedicamentoPage extends StatefulWidget {
  const NewMedicamentoPage({required this.userToken, super.key});
  final String userToken;

  @override
  State<NewMedicamentoPage> createState() => _NewMedicamentoPageState();
}

class _NewMedicamentoPageState extends State<NewMedicamentoPage> {
  late String userToken;

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _formaFarmaceutica = TextEditingController();
  final TextEditingController _fabricante = TextEditingController();
  DateTime _dataFab = DateTime.now();
  DateTime _dataVal = DateTime.now();
  final TextEditingController _prescricao = TextEditingController();
  final TextEditingController _estoque = TextEditingController();

  DateFormatter dateFormatter = DateFormatter();

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;

    print(userToken);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1901),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataFab) {
      setState(() {
        _dataFab = picked;
      });
    }
  }

  Future<void> _selectDateValidade(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataFab,
      firstDate: _dataFab,
      lastDate: DateTime(20101),
    );
    if (picked != null && picked != _dataVal) {
      setState(() {
        _dataVal = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Medicamento'),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
              ? const Center(child: CircularProgressIndicator())
              : _newMedicamento()
        ],
      ),
    );
  }

  Widget _newMedicamento() {
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
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 260,
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _formaFarmaceutica,
                          decoration: const InputDecoration(
                            labelText: "Forma_Farmaceutica",
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
                          controller: _fabricante,
                          decoration: const InputDecoration(
                            labelText: "Fabricante",
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
                          style: const TextStyle(fontSize: 20),
                          readOnly: true,
                          controller: TextEditingController(
                            text: dateFormatter
                                .formatToDDMMYYYY(_dataFab.toLocal())
                                .split(' ')[0],
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Data de Fabricação',
                            hintText: 'Selecione a data',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 20),
                          readOnly: true,
                          controller: TextEditingController(
                            text: dateFormatter
                                .formatToDDMMYYYY(_dataVal.toLocal())
                                .split(' ')[0],
                          ),
                          onTap: () {
                            _selectDateValidade(context);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Data de Validade',
                            hintText: 'Selecione a data',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _prescricao,
                          decoration: const InputDecoration(
                            labelText: "Prescrição Médica",
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
                          controller: _estoque,
                          decoration: const InputDecoration(
                            labelText: "Estoque",
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

                          String response = await cadastraMedicamento(
                              userToken,
                              _nome.text,
                              _formaFarmaceutica.text,
                              _fabricante.text,
                              _dataFab.toString(),
                              _dataVal.toString(),
                              _prescricao.text,
                              _estoque.text);

                          if (response == '201') {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Medicamento Cadastrado',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: Text(
                                    'Nome: ${_nome.text} \nQuantidade: ${_estoque.text}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
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
                                  return const AlertDialog(
                                    title:
                                        Text('Erro ao Cadastrar Medicamento'),
                                  );
                                });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(75, 57, 239, 1),
                            minimumSize: const Size(350, 50)),
                        child: const Text(
                          "Cadastrar",
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
