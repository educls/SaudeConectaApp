import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';

AppConstants constants = AppConstants();

class FetchApiMessages {

  Future<Map<String, dynamic>> fetchMessages(String token) async {

    String url = '${AppConstants.baseUrlApi}/mensagens';
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