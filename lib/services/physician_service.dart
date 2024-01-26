
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';

AppConstants constants = AppConstants();

class FetchApiPhysician {

  void fetchPostPhysician(physician) async {
    String url = '${AppConstants.baseUrlApi}/medicos';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(physician),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print(responseData);
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  Future<String> fetchLoginPhysician(newLogin) async {
    String url = '${AppConstants.baseUrlApi}/login-medico';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newLogin),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final token = responseData['token'];

        print('Token recebido: $token');
        return token.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }

  Future<Map<String, dynamic>> fetchInfoPhysician(String token) async {
    String url = '${AppConstants.baseUrlApi}/medicos/get_info';
    Map<String, dynamic> retornoNull = {};
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        }
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        
        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    }catch(err){
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchPhysicians() async {
    String url = '${AppConstants.baseUrlApi}/medicos/get_whole_infos';
    Map<String, dynamic> retornoNull = {};
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
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
}

