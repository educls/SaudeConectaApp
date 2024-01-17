

import '../services/cep_service.dart';

FetchApiCepToAdress fetchApiCepToAdress = FetchApiCepToAdress();

Future<Map<String, dynamic>> getEnderecoFromApi(String cep) async {

  Map<String, dynamic> adress = await fetchApiCepToAdress.fetchCep(cep);

  return adress;
}