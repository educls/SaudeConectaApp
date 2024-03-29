
import '../models/physician_model.dart';
import '../services/physician_service.dart';

FetchApiPhysician fetchApiPhysician = FetchApiPhysician();

Future<String> cadastraPhysician(String nome, String senha, String cpf, String crm, String especialidade) async {

  PhysicianModel medico = PhysicianModel(nome: nome, senha: senha, cpf: cpf, crm: crm, especialidade: especialidade);
  print(medico);

  String response = await fetchApiPhysician.fetchPostPhysician(medico);

  return response;
}

Future<String> physicianLogin(String crm, String password) async{
  LoginModelPhysician newLogin = LoginModelPhysician(crm: crm, password: password);

  print(newLogin.toJson());

  String userToken = await fetchApiPhysician.fetchLoginPhysician(newLogin);

  return userToken;
}

Future<Map<String, dynamic>> getInfosUserPhysician(String token) async {

  Map<String, dynamic> response = await fetchApiPhysician.fetchInfoPhysician(token);

  return response;
}

Future<Map<String, dynamic>> getPhysicians() async{
  Map<String, dynamic> response = await fetchApiPhysician.fetchPhysicians();

  return response;
}