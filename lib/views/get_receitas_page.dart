

import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/receita_controller.dart';
import '../utils/date_formater.dart';
import 'exibir_pdf_receita_page.dart';


class GetReceitasPage extends StatefulWidget {
  const GetReceitasPage({required this.userToken, super.key});
  final String userToken;

  @override
  State<GetReceitasPage> createState() => _GetReceitasPageState();
}

class _GetReceitasPageState extends State<GetReceitasPage> {
  late String userToken;
  DateFormatter dateFormatter = DateFormatter();

  late Map<String, dynamic> _receitas = {};
  
  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;

    _buscarReceitas(userToken);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setReceitas(receitas){
    setState(() {
      _receitas = receitas;
    });
  }

  Future<void> _buscarReceitas(String userToken) async {
    _setLoading(true);
    Map<String, dynamic> fetchReceitasForsetState = await getReceitas(userToken);
    _setReceitas(fetchReceitasForsetState);
    
    Timer(const Duration(milliseconds: 500),(){
      _setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
            ? const Center(child: CircularProgressIndicator())
            : (_receitas == null || _receitas['receitas'] == null || _receitas['receitas'].isEmpty)
              ? const Center(child: Text('Nenhuma Receita Encontrada'))
              : _buildFormReceitas(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buscarReceitas(userToken);
        },
        tooltip: 'Recarregar',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildFormReceitas(){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: (_receitas == {} || _receitas!['receitas'] == null)
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: _receitas!['receitas'].length,
          itemBuilder: (BuildContext context, int index){
            final receita = _receitas['receitas'][index];
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
                  '${receita['Especialidade']} \n ${dateFormatter.convertToDateTime(receita['DataEmissao'])}'
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExibirPdfReceitaPage(nomeArquivo: '${receita['ID_Paciente']}_${receita['ID_Receita']}_receita.pdf')
                      ),
                    );
                  }, 
                  child: const Icon(Icons.remove_red_eye_sharp)
                ),
                onTap: () async {
                  print(dateFormatter.convertToDateTime(receita['DataConsulta']));
                },
              ),
            );
          }

        ),
      ),
    );
  }
}