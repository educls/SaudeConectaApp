import 'package:http/http.dart' as http;
import 'dart:convert';


class FetchApiCepToAdress {
  
  Future<Map<String, dynamic>> fetchCep(String cep) async {
  String url = 'https://viacep.com.br/ws/$cep/json/';
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