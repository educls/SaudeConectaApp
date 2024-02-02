import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../controllers/medicamento_controller.dart';
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
  bool precricaoChecked = false;
  final ValueNotifier<String> _dropValueFormaFarmaceutica = ValueNotifier<String>('');
  Map<String, String> dropdownOptionsFormaFarmaceutica = {
    'Comprimido ': 'Comprimido ',
    'Cápsula': 'Cápsula',
    'Xarope': 'Xarope',
    'Solução': 'Solução',
    'Injeção': 'Injeção',
    'Pomadas': 'Pomadas',
    'Supositório': 'Supositório',
    'Aerossól': 'Aerossól',
    'Gota': 'Gota'
  };

  DateFormatter dateFormatter = DateFormatter();

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;
    _prescricao.text = 'nao';

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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
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
                        child: ValueListenableBuilder<String>(
                          valueListenable: _dropValueFormaFarmaceutica, 
                          builder: (BuildContext context, String value, _) {
                            return DropdownButton(
                              isExpanded: true,
                              hint: const Text("Selecione uma Forma Farmacêutica"),
                              value: (value.isEmpty) ? null : value,
                              onChanged: (choice) => {
                                _dropValueFormaFarmaceutica.value = choice.toString()
                              },
                              onTap: () {
                                print(_dropValueFormaFarmaceutica.value);
                              },
                              items: dropdownOptionsFormaFarmaceutica.keys.map((String op) {
                                return DropdownMenuItem(
                                  value: op,
                                  child: Text(dropdownOptionsFormaFarmaceutica[op]!)
                                );
                              }).toList(),
                            );
                          }
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Checkbox(
                                value: precricaoChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    precricaoChecked = value!;
                                  });
                                  if (precricaoChecked == false) {
                                    _prescricao.text = 'nao';
                                  } else {
                                    _prescricao.text = 'sim';
                                  }
                                  print(_prescricao.text);
                                }),
                            const Text(
                              "Precrição Medica",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                          await Future.delayed(
                              const Duration(milliseconds: 500));

                          List<String> campos = [
                            _nome.text,
                            _dropValueFormaFarmaceutica.value,
                            _fabricante.text,
                            _dataFab.toString(),
                            _dataVal.toString(),
                            _prescricao.text,
                            _estoque.text,
                          ];
                          if (campos.any((campo) => campo.isEmpty)) {
                            _setLoading(false);
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: Text("Um dos campos está vazio"),
                                );
                              },
                            );
                          } else {
                            String response = await cadastraMedicamento(
                                userToken,
                                _nome.text,
                                _dropValueFormaFarmaceutica.value,
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
