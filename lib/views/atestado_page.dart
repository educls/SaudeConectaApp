
import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/atestado_controller.dart';
import '../models/atestado_model.dart';
import '../models/pop_up_model_atestado.dart';
import '../utils/gera_atestado_pdf.dart';


class AtestadoPage extends StatefulWidget {
  const AtestadoPage({required this.userToken, required this.newAtestado, Key? key}) : super(key: key);
  final PopUpModelForPhysician newAtestado;
  final String userToken;

  @override
  State<AtestadoPage> createState() => _AtestadoPageState();
}

class _AtestadoPageState extends State<AtestadoPage> {

  final TextEditingController _nomeMedico = TextEditingController();
  final TextEditingController _crm = TextEditingController();
  final TextEditingController _nomePaciente = TextEditingController();
  final TextEditingController _data = TextEditingController();
  final TextEditingController _motivo = TextEditingController();
  final TextEditingController _diasAfastamento = TextEditingController();
  final TextEditingController _cidade = TextEditingController();
  final TextEditingController _estado = TextEditingController();

  late final PopUpModelForPhysician newAtestado;
  late final String userToken;

  @override
  void initState(){
    super.initState();
    newAtestado = widget.newAtestado;
    userToken = widget.userToken;

    _setInfosForAtestado(newAtestado);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _setInfosForAtestado(PopUpModelForPhysician newAtestado) async {
    _nomeMedico.text = newAtestado.nomeMedico;
    _crm.text = '';
    _nomePaciente.text = newAtestado.nomePaciente;
    _data.text = newAtestado.dataConsulta;
    _motivo.text = '';
    _diasAfastamento.text = '';
    _cidade.text = '';
    _estado.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atestado Pagina'),
      ),
      body: (_isLoading)
      ? const Center(child: CircularProgressIndicator())
      : _buildForm()
    );
  }


  Widget _buildForm(){
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
              decoration: const InputDecoration(labelText: 'Nome do Médico'),
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
              decoration: const InputDecoration(labelText: 'Nome do Paciente'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _data,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Data da Consulta'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _motivo,
              decoration: const InputDecoration(labelText: 'Motivo do Atestado'),
              maxLines: 4,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _diasAfastamento,
              decoration: const InputDecoration(labelText: 'Dias de Afastamento'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cidade,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _estado,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                _setLoading(true);

                Timer(const Duration(milliseconds: 1000), () {

                  AtestadoMedicoModel novoAtestado = AtestadoMedicoModel(
                    nomeMedico: _nomeMedico.text, 
                    crm: _crm.text, 
                    nomePaciente: _nomePaciente.text, 
                    data: _data.text, 
                    motivo: _motivo.text, 
                    diasAfastamento: _diasAfastamento.text, 
                    cidade: _cidade.text, 
                    estado: _estado.text
                  );
                
                  String atestado = gerarAtestadoPdf(novoAtestado);

                  atestadoEmitir(newAtestado, atestado, userToken);

                  Navigator.of(context).pop();

                });
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                minimumSize: const Size(70, 50)
              ),
              child: const Text(
                'Emitir Atestado',
                style: TextStyle(
                  color: Colors.white
                ),
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