
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/receita_medica_model.dart';
import '../utils/constants.dart';

AppConstants constants = AppConstants();

class FetchApiReceitas {
  
  Future<Map<String, dynamic>> fetchEmitirReceitaPdf(ReceitaPdfModel novaReceita, String token) async {

    String url = '${AppConstants.baseUrlApi}/receita-gerar';
    Map<String, dynamic> retornoNull = {};
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(novaReceita),
      );
      if (response.statusCode == 201) {
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

  Future<Map<String, dynamic>> fetchReceitas(String token) async {

    String url = '${AppConstants.baseUrlApi}/receita-gerar/get_info';
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
}