


import '../models/change_state_schedule.dart';
import '../models/schedule_model.dart';
import '../services/fetch_consultas_service.dart';

FetchApiConsultas fetchApiConsultas = FetchApiConsultas();

Future<Map<String, dynamic>> getConsultasPatient(String token) async{

  Map<String, dynamic> response = await fetchApiConsultas.fetchConsultasForMedicos(token);

  return response;
}

Future<Map<String, dynamic>> getConsultasPhysician(String token) async{

  Map<String, dynamic> response = await fetchApiConsultas.fetchConsultasForMedicos(token);

  return response;
}

Future<bool> cadastraConsulta(String idMedico, String especialidade, String data, String hora, String userToken) async{
  ScheculeModel newSchedule = ScheculeModel(idMedico: idMedico, especialidade: especialidade, data: data, hora: hora);

  String response = await fetchApiConsultas.fetchPostConsulta(newSchedule, userToken);

  if(response != null){
    return true;
  }else{
    return false;
  }
}

Future<String> changeSateConsulta(String idConsulta, String state, String userToken) async{
  ChangeStateScheduleModel newStateSchedule = ChangeStateScheduleModel(idConsulta: idConsulta, state: state);

  String response = await fetchApiConsultas.fetchChangeStateConsulta(newStateSchedule, userToken);

  return response;
}

Future<String> deleteConsulta(String token, String idConsulta) async{

  String response = await fetchApiConsultas.fetchDeleteConsulta(token, idConsulta);

  return response;
}