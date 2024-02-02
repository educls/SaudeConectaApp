




import '../models/medicamento_model.dart';
import '../models/update_medicamento_model.dart';
import '../services/medicamento_service.dart';
import '../utils/date_formater.dart';

  FetchApiMedicamentos fetchApiMedicamentos = FetchApiMedicamentos();

Future<String> cadastraMedicamento(String token, String nome, String formaFarmaceutica, String fab, String dataFab, String dataVal, String prescricaoMedica, String estoque) async {
  MedicamentoModel novoMedicamento = MedicamentoModel(
    nomeMedicamento: nome, 
    formaFarmaceutica: formaFarmaceutica, 
    fabricante: fab, 
    dataFabricacao: dataFab, 
    dataValidade: dataVal, 
    prescricaoMedica: prescricaoMedica, 
    estoque: estoque
  );

  String response = await fetchApiMedicamentos.fetchPostMedicamentos(token, novoMedicamento);

  return response;
}

Future<Map<String, dynamic>> getMedicamentos(String token) async {

  Map<String, dynamic> response = await fetchApiMedicamentos.fetchMedicamentos(token);

  return response;
}

Future<String> updateMedicamento(String token, String estoque, String idMedicamento) async {
  UpdateMedicamentoModel updateCadastroModel = UpdateMedicamentoModel(idMedicamento: idMedicamento, estoque: estoque);

  String response = await fetchApiMedicamentos.fetchUpdateMedicamento(token, updateCadastroModel);

  return response;
}

Future<Map<String, dynamic>> getMedicamento(String token, String search) async {

  Map<String, dynamic> response = await fetchApiMedicamentos.fetchMedicamento(token, search);

  return response;
}

Future<List<String>> getAutoCompleteMedicamentos(String token, String search) async {

  Map<String, dynamic> response = await fetchApiMedicamentos.fetchNameForAutoComplete(token, search);

  List<String> listaMedicamentos = List<String>.from(response["searchMedicamentos"]);

  print(listaMedicamentos);

  return listaMedicamentos;
}

Future<String> deleteMedicamento(String token, String idMedicamento) async {

  String response = await fetchApiMedicamentos.fetchDeleteMedicamento(token, idMedicamento);

  return response;
}