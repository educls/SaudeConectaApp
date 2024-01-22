import '../services/medicamento_service.dart';
import '../utils/date_formater.dart';

  FetchApiMedicamentos fetchApiMedicamentos = FetchApiMedicamentos();

Future<Map<String, dynamic>> getMedicamentos(String token) async {

  Map<String, dynamic> response = await fetchApiMedicamentos.fetchMedicamentos(token);

  return response;
}

Future<List<String>> getAutoCompleteMedicamentos(String token, String search) async {

  Map<String, dynamic> response = await fetchApiMedicamentos.fetchNameForAutoComplete(token, search);
  
  List<String> searchMedicamentos = response['medicamentos']
      .map<String>((medicamento) => medicamento['Nome_Medicamento'] as String)
      .toList();
  print(searchMedicamentos);

  return searchMedicamentos;
}