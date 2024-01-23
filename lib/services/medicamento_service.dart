
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/medicamento_model.dart';
import '../utils/constants.dart';

AppConstants constants = AppConstants();

class FetchApiMedicamentos {

  Future<String> fetchPostMedicamentos(String token, MedicamentoModel novoMedicamento) async {

    String url = '${AppConstants.baseUrlApi}/medicamentos';
    String retornoNull = '';
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(novoMedicamento),
      );
      if (response.statusCode == 201) {
        
        return response.statusCode.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
        print(response.body);
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchMedicamentos(String token) async {

    String url = '${AppConstants.baseUrlApi}/medicamentos/get_whole_infos';
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
        print(response.body);
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchMedicamento(String token, String search) async {

    String url = '${AppConstants.baseUrlApi}/medicamentos/get_info_medicamento/$search';
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
        print(responseData);
        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
        print(response.body);
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchNameForAutoComplete(String token, String search) async {

    String url = '${AppConstants.baseUrlApi}/medicamentos/get_infos_like/$search';
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
        print(response.body);
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<String> fetchDeleteMedicamento(String token, String idMedicamento)async {

    String url = '${AppConstants.baseUrlApi}/medicamentos/$idMedicamento';
    String retornoNull = '';
    try{
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        }
      );
      if (response.statusCode == 200) {

        return response.statusCode.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
        print(response.body);
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

}