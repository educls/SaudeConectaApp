
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/change_state_schedule.dart';
import '../models/schedule_model.dart';
import '../utils/constants.dart';

AppConstants constants = AppConstants();

class FetchApiConsultas {

  Future<Map<String, dynamic>> fetchConsultasForPatient(String token) async {
    String url = '${AppConstants.baseUrlApi}/consulta-agendar/get_info';
    Map<String, dynamic> retornoNull = {};
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        }
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchConsultasForMedicos(String token) async {

    String url = '${AppConstants.baseUrlApi}/consulta-agendar/get_consultas_medico';
    Map<String, dynamic> retornoNull = {};
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        }
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }


  Future<String> fetchPostConsulta(ScheculeModel newSchedule, String userToken) async {
    String url = '${AppConstants.baseUrlApi}/consulta-agendar';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        },
        body: jsonEncode(newSchedule),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        return responseData.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }

  Future<String> fetchDeleteConsulta(String userToken, String idConsulta) async {
    String url = '${AppConstants.baseUrlApi}/consulta-agendar/$idConsulta';
    print(url);

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        return response.statusCode.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }

  Future<String> fetchChangeStateConsulta(ChangeStateScheduleModel newStateSchedule, String userToken) async{
    String url = '${AppConstants.baseUrlApi}/consulta-agendar/change-state-schedule';
    print(url);
    print(userToken);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        },
        body: jsonEncode(newStateSchedule),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        return responseData.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }
}

