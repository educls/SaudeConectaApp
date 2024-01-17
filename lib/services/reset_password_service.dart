
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/reset_password_model.dart';
import '../utils/constants.dart';


AppConstants constants = AppConstants();

class FetchApiResetPassword {
  
  Future<Map<String, dynamic>> fetchResetPassword(ResetPassModel novaSenha) async {

  String url = '${AppConstants.baseUrlApi}/reset_pass_with_code';
  Map<String, dynamic> retornoNull = {};
  try{
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(novaSenha),
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
}