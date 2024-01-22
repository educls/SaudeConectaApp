import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medicamento_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

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
  late String userToken;
  String? selectedAutoComplete;

  List<String> searchMedicamentos = <String>[];

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;

    _buscaMedicamentos(userToken);
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _setMedicamentos(fetchMedicamentosForState) {
    setState(() {
      medicamentosInfos = fetchMedicamentosForState;
    });
  }

  Future<void> _buscaMedicamentos(String userToken) async {
    Map<String, dynamic> fetchMedicamentosForState = await getMedicamentos(userToken);

    _setMedicamentos(fetchMedicamentosForState);
  }

  Future<void> _buscaAutoComplete(String userToken, String search) async{
    List<String> fetchsearchMedicamentos = await getAutoCompleteMedicamentos(userToken, search);

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
        body: Stack(
          children: [
            (_isLoading == true)
              ? const Center(child: CircularProgressIndicator())
              : (medicamentosInfos == null || medicamentosInfos['medicamentos'] == null || medicamentosInfos['medicamentos'].isEmpty)
                ? const Center(child: Text("Nenhum Medicamento Encontrado"))
                : _searchWidget()
          ]
        ),
    );
  }

Widget _searchWidget() {
  return Scaffold(
    body: Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return searchMedicamentos.where((String item) {
                  return item.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String item) {
                setState(() {
                  searchController.text = item;
                });
              },
              fieldViewBuilder: (BuildContext context, TextEditingController search, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: search,
                  focusNode: focusNode,
                  onChanged: (String value) {
                    searchController.text = value;
                    print(searchController.text);
                    if(value == null){
                      print("nenhuma busca");
                    }else{
                      _buscaAutoComplete(userToken, value);
                    }
                    
                  },
                  decoration: InputDecoration(
                    hintText: 'Digite sua busca',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.text = '';
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  print(search);
                },
                child: const Text('Buscar'),
              ),
        Expanded(
          child: ListView.builder(
            itemCount: medicamentosInfos!['medicamentos'].length,
            itemBuilder: (BuildContext context, int index) {
              final medicamento = medicamentosInfos['medicamentos'][index];
              return AnimationConfiguration.staggeredList(
                position: index,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        print("apertado");
                      },
                      title: Text(
                        '${medicamento['Nome_Medicamento']}  (${medicamento['Fabricante']}) \n Validade: ${dateFormatter.convertToDateTime(medicamento['Data_Validade'])} \n ${medicamento['Forma_Farmaceutica']}'
                      ),
                      trailing: Text(
                        'Estoque: \n ${medicamento['Estoque']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


}




