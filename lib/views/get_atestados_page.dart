import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/atestado_controller.dart';
import '../utils/class/Theme.dart';
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  void _setAtestados(atestados) {
    setState(() {
      _atestados = atestados;
    });
  }

  Future<void> _buscarAtestados(String userToken) async {
    _setLoading(true);
    Map<String, dynamic> fetchAtestadosForsetState =
        await getAtestados(userToken);
    _setAtestados(fetchAtestadosForsetState);

    Timer(const Duration(milliseconds: 500), () {
      _setLoading(false);
    });
  }

  void _onRefresh() async {
    Map<String, dynamic> fetchAtestadosForsetState =
        await getAtestados(userToken);
    _setAtestados(fetchAtestadosForsetState);

    await Future.delayed(const Duration(milliseconds: 1000));
    _setLoading(true);
    Timer(const Duration(milliseconds: 100), () {
      _setLoading(false);
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atestados',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(
        children: [
          (_isLoading == true)
              ? const Center(child: CircularProgressIndicator())
              : (_atestados == null ||
                      _atestados['atestados'] == null ||
                      _atestados['atestados'].isEmpty)
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

  Widget _buildFormAtestados() {
    return Scaffold(
      body: (_atestados == {} || _atestados!['atestados'] == null)
          ? const Center(child: CircularProgressIndicator())
          : AnimationLimiter(
              child: SmartRefresher(
                enablePullDown: true,
                header: WaterDropMaterialHeader(
                  color: Colors.white,
                  backgroundColor:
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? const Color.fromARGB(255, 35, 35, 36)
                          : const Color.fromARGB(255, 54, 158, 255),
                ),
                footer: const ClassicFooter(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                    itemCount: _atestados!['atestados'].length,
                    itemBuilder: (BuildContext context, int index) {
                      final atestado = _atestados['atestados'][index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: FadeInAnimation(
                            child: Card(
                          margin: const EdgeInsets.only(
                              right: 15, left: 15, top: 25),
                          elevation: 10,
                          child: ListTile(
                            title: Text(
                                '${atestado['Especialidade']} \n ${dateFormatter.convertToDateTime(atestado['DataEmissao'])}'),
                            trailing: Card(
                              color: Provider.of<ThemeProvider>(context).isDarkMode 
                                              ? const Color.fromARGB(255, 102, 102, 102)
                                              : const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                              ),
                              elevation: 10,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExibirPdfPage(
                                              nomeArquivo:
                                                  '${atestado['ID_Paciente']}_${atestado['ID_Atestado']}_atestado.pdf')),
                                    );
                                  },
                                  icon: const Icon(Icons.remove_red_eye_sharp),
                                  iconSize: 30,
                                  color: Provider.of<ThemeProvider>(context)
                                          .isDarkMode
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : const Color.fromARGB(
                                          255, 119, 119, 119)),
                            ),
                            onTap: () async {
                              print(dateFormatter
                                  .convertToDateTime(atestado['DataConsulta']));
                            },
                          ),
                        )),
                      );
                    }),
              ),
            ),
    );
  }
}
