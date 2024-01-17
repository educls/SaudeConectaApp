
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/horario_model.dart';
import '../utils/constants.dart';


AppConstants constants = AppConstants();

Future<Map<String, dynamic>> fetchHorariosDisponiveis(HorarioModel novaBuscaHorario) async {

  String url = '${AppConstants.baseUrlApi}/get_horarios_disponiveis';
  Map<String, String> retornoNull = {};
  try{
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(novaBuscaHorario),
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