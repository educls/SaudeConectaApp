import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../utils/class/Theme.dart';
import '../utils/date_formater.dart';

class EditMedicamentoPage extends StatefulWidget {
  EditMedicamentoPage({required this.userToken, super.key, required this.medicamento});
  final String userToken;
  Map<String, dynamic> medicamento = {};

  @override
  State<EditMedicamentoPage> createState() => _EditMedicamentoPageState();
}

class _EditMedicamentoPageState extends State<EditMedicamentoPage> {
  late String userToken;
  Map<String, dynamic> medicamento = {};

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _formaFarmaceutica = TextEditingController();
  final TextEditingController _fabricante = TextEditingController();
  DateTime _dataFab = DateTime.now();
  DateTime _dataVal = DateTime.now();
  final TextEditingController _prescricao = TextEditingController();
  final TextEditingController _estoque = TextEditingController();

  DateFormatter dateFormatter = DateFormatter();

  @override
  void initState(){
    super.initState();
    medicamento = widget.medicamento;
    userToken = widget.userToken;

    _setInfosMedicamento(medicamento);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _setInfosMedicamento(medicamento) async {
    _nome.text = medicamento['Nome_Medicamento'];
    _formaFarmaceutica.text = medicamento['Forma_Farmaceutica'];
    _fabricante.text = medicamento['Fabricante'];
    _dataFab = DateTime.parse(medicamento['Data_Fabricacao']);
    _dataVal = DateTime.parse(medicamento['Data_Validade']);
    _prescricao.text = medicamento['Prescricao_Medica'];
    _estoque.text = medicamento['Estoque'].toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(20101),
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
        title: const Text('Editar Medicamento'),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
            ? const Center(child: CircularProgressIndicator())
            : _editMedicamento()
        ],
      ),
    );
  }

  Widget _editMedicamento() {
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
                          enabled: false,
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
                          enabled: false,
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
                          enabled: false,
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
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          readOnly: true,
                          enabled: false,
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
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          readOnly: true,
                          enabled: false,
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
                          enabled: false,
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
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                          minimumSize: const Size(350, 50)
                        ),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}