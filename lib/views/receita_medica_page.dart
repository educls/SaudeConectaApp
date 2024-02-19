import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/notification_controller.dart';

import '../controllers/receita_controller.dart';
import '../models/pop_up_model_atestado.dart';
import '../models/receita_medica_model.dart';
import '../utils/date_formater.dart';
import '../utils/gera_atestado_pdf.dart';

class ReceitaMedicaPage extends StatefulWidget {
  const ReceitaMedicaPage(
      {required this.userToken,
      required this.newAtestado,
      required this.tokenFirebase,
      Key? key})
      : super(key: key);
  final PopUpModelForPhysician newAtestado;
  final String userToken;
  final String tokenFirebase;

  @override
  State<ReceitaMedicaPage> createState() => _ReceitaMedicaPageState();
}

class _ReceitaMedicaPageState extends State<ReceitaMedicaPage> {
  final TextEditingController _nomeMedico = TextEditingController();
  final TextEditingController _crm = TextEditingController();
  final TextEditingController _nomePaciente = TextEditingController();
  final TextEditingController _data = TextEditingController();
  final TextEditingController _medicamentoNome = TextEditingController();
  final TextEditingController _medicamentoDozagem = TextEditingController();
  final TextEditingController _receitaValidade = TextEditingController();
  final TextEditingController _obs = TextEditingController();
  DateFormatter dateFormatter = DateFormatter();
  DateTime _selectedDate = DateTime.now();

  late final PopUpModelForPhysician newAtestado;
  late final String userToken;
  late String tokenFirebase;

  @override
  void initState() {
    super.initState();
    newAtestado = widget.newAtestado;
    userToken = widget.userToken;
    tokenFirebase = widget.tokenFirebase;

    _setInfosForReceita(newAtestado);
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
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(20101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _setInfosForReceita(PopUpModelForPhysician newAtestado) async {
    _nomeMedico.text = newAtestado.nomeMedico;
    _crm.text = '';
    _nomePaciente.text = newAtestado.nomePaciente;
    _data.text = newAtestado.dataConsulta;
    _medicamentoNome.text = '';
    _medicamentoDozagem.text = '';
    _receitaValidade.text = '';
    _obs.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Receita Medica'),
        ),
        body: (_isLoading == true)
            ? const Center(child: CircularProgressIndicator())
            : _buildForm());
  }

  Widget _buildForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nomeMedico,
                  enabled: false,
                  decoration:
                      const InputDecoration(labelText: 'Nome do Médico'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _crm,
                  decoration: const InputDecoration(labelText: 'Numero CRM'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nomePaciente,
                  enabled: false,
                  decoration:
                      const InputDecoration(labelText: 'Nome do Paciente'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _data,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Data'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _medicamentoNome,
                  decoration:
                      const InputDecoration(labelText: 'Nome do Medicamento'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _medicamentoDozagem,
                  decoration: const InputDecoration(
                      labelText: 'Dozagens do Medicamento'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: dateFormatter
                        .formatToDDMMYYYY(_selectedDate.toLocal())
                        .split(' ')[0],
                  ),
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento',
                    hintText: 'Selecione a data',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _obs,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 4,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _setLoading(true);

                    Timer(const Duration(milliseconds: 1000), () {
                      ReceitaMedicaModel novaReceita = ReceitaMedicaModel(
                          nomeMedico: _nomeMedico.text,
                          crm: _crm.text,
                          nomePaciente: _nomePaciente.text,
                          data: _data.text,
                          medicamentoNome: _medicamentoNome.text,
                          medicamentoDozagem: _medicamentoDozagem.text,
                          receitaValidade: _receitaValidade.text,
                          obs: _obs.text);

                      String receita = gerarReceitaPdf(novaReceita);

                      receitaEmitir(newAtestado, receita, userToken);

                      sendNotification(tokenFirebase, "Nova Receita Medica",
                          'Medicamento: ${_medicamentoNome.text}  ${_medicamentoDozagem.text}');

                      Navigator.of(context).pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                      minimumSize: const Size(70, 50)),
                  child: const Text(
                    'Emitir Receita',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
