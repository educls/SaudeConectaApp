import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/atestado_controller.dart';
import '../utils/date_formater.dart';
import 'exibir_pdf_atestado_page.dart';


class GetAtestadosPage extends StatefulWidget {
  const GetAtestadosPage({required this.userToken, Key? key}) : super(key: key);
  final String userToken;

  @override
  State<GetAtestadosPage> createState() => _GetAtestadosPageState();
}

class _GetAtestadosPageState extends State<GetAtestadosPage> {

  late String userToken;
  DateFormatter dateFormatter = DateFormatter();

  late Map<String, dynamic> _atestados = {};

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;

    _buscarAtestados(userToken);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setAtestados(atestados){
    setState(() {
      _atestados = atestados;
    });
  }

  Future<void> _buscarAtestados(String userToken) async {
    _setLoading(true);
    Map<String, dynamic> fetchAtestadosForsetState = await getAtestados(userToken);
    _setAtestados(fetchAtestadosForsetState);

    Timer(const Duration(milliseconds: 500),(){
      _setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atestados',
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
            ? const Center(child: CircularProgressIndicator())
            : (_atestados == null || _atestados['atestados'] == null || _atestados['atestados'].isEmpty)
              ? const Center(child: Text('Nenhum Atestado Encontrado'))
              : _buildFormAtestados(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buscarAtestados(userToken);
        },
        tooltip: 'Recarregar',
        child: const Icon(Icons.refresh),
      ),
    );
  }


  Widget _buildFormAtestados(){
    return Scaffold(
        body: (_atestados == {} || _atestados!['atestados'] == null)
        ? const Center(child: CircularProgressIndicator())
        :ListView.builder(
          itemCount: _atestados!['atestados'].length,
          itemBuilder: (BuildContext context, int index) {
            final atestado = _atestados['atestados'][index];
            return Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  '${atestado['Especialidade']} \n ${dateFormatter.convertToDateTime(atestado['DataEmissao'])}'
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExibirPdfPage(nomeArquivo: '${atestado['ID_Paciente']}_${atestado['ID_Atestado']}_atestado.pdf')
                      ),
                    );
                  }, 
                  child: const Icon(Icons.remove_red_eye_sharp)
                ),
                onTap: () async {
                  print(dateFormatter.convertToDateTime(atestado['DataConsulta']));
                },
              ),
            );
          }
        ),
    );
  }
}


