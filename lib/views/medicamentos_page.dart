import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medicamento_controller.dart';
import 'package:flutter_application_1/views/edit_medicamento_page.dart';
import 'package:flutter_application_1/views/new_medicamento_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/class/Theme.dart';
import '../utils/date_formater.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({required this.userToken, Key? key}) : super(key: key);
  final String userToken;

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  DateFormatter dateFormatter = DateFormatter();
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> medicamentosInfos = {};
  Map<String, dynamic> fetchMedicamentosForState = {};
  late String userToken;
  String? selectedAutoComplete;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<String> searchMedicamentos = <String>[];

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;

    reloadConsultas();
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> reloadConsultas() async {
    _setLoading(true);
    _buscaMedicamentos(userToken);

    await Future.delayed(const Duration(milliseconds: 1000));
    
    Timer(const Duration(milliseconds: 100), () {
      _setMedicamentos(fetchMedicamentosForState);
      _setLoading(false);
    });
  }

  void _setMedicamentos(fetchMedicamentosForState) {
    setState(() {
      medicamentosInfos = fetchMedicamentosForState;
      searchController.text = '';
    });
    _setLoading(false);
  }

  Future<void> _buscaMedicamento(String userToken, String search) async {
    _setLoading(true);
    Map<String, dynamic> fetchMedicamentoForState =
        await getMedicamento(userToken, search);

    await Future.delayed(const Duration(milliseconds: 500));
    _setMedicamentos(fetchMedicamentoForState);
  }

  Future<void> _buscaMedicamentos(String userToken) async {
    fetchMedicamentosForState =
        await getMedicamentos(userToken);

    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _onRefresh() async {
    _buscaMedicamentos(userToken);

    await Future.delayed(const Duration(milliseconds: 1000));
    
    _setLoading(true);
    Timer(const Duration(milliseconds: 100), () {
      _setMedicamentos(fetchMedicamentosForState);
      _setLoading(false);
    });

    _refreshController.refreshCompleted();
  }

  Future<void> _buscaAutoComplete(String userToken, String search) async {
    List<String> fetchsearchMedicamentos =
        await getAutoCompleteMedicamentos(userToken, search);

    setState(() {
      searchMedicamentos = fetchsearchMedicamentos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.lightBlue,
        title: const Text('Medicamentos'),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(children: [
        (_isLoading == true)
            ? const Center(child: CircularProgressIndicator())
            : _searchWidget()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewMedicamentoPage(userToken: userToken)),
          );
        },
        tooltip: 'Novo Medicamento',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _searchWidget() {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 100
                    ),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final String query = textEditingValue.text.toLowerCase();
                        if (query.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return searchMedicamentos.where((String item) {
                          return item.toLowerCase().contains(query);
                        });
                      },
                      onSelected: (String item) {
                        setState(() {
                          searchController.text = item;
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController search,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: search,
                          focusNode: focusNode,
                          onChanged: (String value) {
                            if (value == '') {
                              print("nenhuma busca");
                              searchController.text = '';
                            } else {
                              _buscaAutoComplete(userToken, value);
                              searchController.text = value;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Digite sua busca',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  search.text = '';
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    String search = searchController.text;
                    if (search == '') {
                      _buscaMedicamentos(userToken);
                    } else {
                      _buscaMedicamento(userToken, search);
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimationLimiter(
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
                child: (medicamentosInfos == '' || medicamentosInfos == null || medicamentosInfos['medicamentos'] == null || medicamentosInfos['medicamentos'].isEmpty)
                    ? _widgetConsultasIsEmpty()
                    : ListView.builder(
                        itemCount: medicamentosInfos!['medicamentos'].length,
                        itemBuilder: (BuildContext context, int index) {
                          final medicamento =
                              medicamentosInfos['medicamentos'][index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    title: Text(
                                        '${medicamento['Nome_Medicamento']}  (${medicamento['Fabricante']}) \n Validade: ${dateFormatter.convertToDateTime(medicamento['Data_Validade'])} \n ${medicamento['Forma_Farmaceutica']}'),
                                    trailing: Text(
                                      'Estoque: \n ${medicamento['Estoque']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                '${medicamento['Nome_Medicamento']}'),
                                            content: Text(
                                                '${medicamento['Fabricante']}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  _setLoading(true);
                                                  Navigator.of(context).pop();
                                                  var response =
                                                      await deleteMedicamento(
                                                          userToken,
                                                          medicamento[
                                                                  'ID_Medicamento']
                                                              .toString());

                                                  if (response == '200') {
                                                    _onRefresh();
                                                  }
                                                },
                                                child: const Text('Excluir'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditMedicamentoPage(
                                                                userToken:
                                                                    userToken,
                                                                medicamento:
                                                                    medicamento)),
                                                  );
                                                },
                                                child: const Text('Editar'),
                                              ),
                                              Card(
                                                elevation: 2,
                                                child: TextButton(
                                                  onPressed: () {
                                                    print(medicamento[
                                                        'Prescricao_Medica']);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Voltar'),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _widgetConsultasIsEmpty() {
  return const Center(
    child: Text(
      'Não há consultas cadastradas.',
      style: TextStyle(fontSize: 18.0),
    ),
  );
}
