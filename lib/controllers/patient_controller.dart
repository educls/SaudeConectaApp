


import '../models/patient_model.dart';
import '../services/patient_service.dart';

FetchApiPatient fetchApiPatient = FetchApiPatient();

bool cadastraPatient(String nome, String email, String senha, String cpf, String telefone, String estado, String cidade, String bairro, String rua, String numero) {
  Endereco endereco = Endereco(estado: estado, cidade: cidade, bairro: bairro, rua: rua, numero: numero);

  PatientModel paciente = PatientModel(nome: nome, email: email, senha: senha, cpf: cpf, telefone: telefone, endereco: endereco);

  fetchApiPatient.fetchPostPatient(paciente);

  return false;
}

bool patientSendCodeEmail(String email){
  EmailSendCode emailJson = EmailSendCode(email: email);

  fetchApiPatient.fetchSendCodeInEmail(emailJson);

  return false;
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

bool returFalse(){
  return false;
}