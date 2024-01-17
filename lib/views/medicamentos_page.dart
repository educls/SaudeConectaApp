import 'package:flutter/material.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.lightBlue,
          title: const Text('Medicamentos'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchWidget(),
        ),
    );
  }


  Widget SearchWidget(){
      return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Digite sua busca',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            String search = _searchController.text;

            print('Buscando por: $search');
          },
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}