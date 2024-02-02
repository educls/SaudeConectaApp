


import '../models/patient_model.dart';
import '../services/patient_service.dart';

FetchApiPatient fetchApiPatient = FetchApiPatient();

Future<String> cadastraPatient(String nome, String email, String senha, String cpf, String telefone, String estado, String cidade, String bairro, String rua, String numero) async {
  Endereco endereco = Endereco(estado: estado, cidade: cidade, bairro: bairro, rua: rua, numero: numero);

  PatientModel paciente = PatientModel(nome: nome, email: email, senha: senha, cpf: cpf, telefone: telefone, endereco: endereco);

  String response = await fetchApiPatient.fetchPostPatient(paciente);

  return response;
}

Future<String> atualizaCadastro(String userToken, String senha, String telefone, String estado, String cidade, String bairro, String rua, String numero) async {

  Endereco endereco = Endereco(estado: estado, cidade: cidade, bairro: bairro, rua: rua, numero: numero);
  UpdateCadastroModel updateCadastro = UpdateCadastroModel(senha: senha, telefone: telefone, endereco: endereco);
  
  String response = await fetchApiPatient.fetchUpdateUser(updateCadastro, userToken);

  return response;
}

Future<String> patientSendCodeEmail(String email) async{
  EmailSendCode emailJson = EmailSendCode(email: email);

  String response = await fetchApiPatient.fetchSendCodeInEmail(emailJson);

  return response;
}

Future<String> patientLogin(String email, String password) async{
  LoginModel newLogin = LoginModel(email: email, password: password);

  String userToken = await fetchApiPatient.fetchLoginPatient(newLogin);

  return userToken;
}

Future<Map<String, dynamic>> getInfosUserPatient(String token) async{

  Map<String, dynamic> response = await fetchApiPatient.fetchInfoPatient(token);

  return response;
}

Future<Map<String, dynamic>> getInfosUserEndereco(String token) async{
  
  Map<String, dynamic> response = await fetchApiPatient.fetchInfoPatientEndereco(token);

  return response;
}

bool returFalse(){
  return false;
}