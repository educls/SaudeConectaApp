import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';

class FetchApiPatient {
  AppConstants constants = AppConstants();

  Future<String> fetchPostPatient(patientModel) async {
    String url = '${AppConstants.baseUrlApi}/usuarios';
    print(patientModel);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patientModel),
      );

      if (response.statusCode == 201) {
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

  Future<String> fetchSendCodeInEmail(email) async {
    String url = '${AppConstants.baseUrlApi}/enviar-email-verificacao';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(email),
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

  Future<String> fetchLoginPatient(newLogin) async {
    String url = '${AppConstants.baseUrlApi}/login';

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

        print(response.body);

        final token = responseData['token'];

        print('Token recebido: $token');
        return token.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
        print(response.body);
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }

  Future<String> fetchUpdateUser(update, String token) async {
    String url = '${AppConstants.baseUrlApi}/usuarios/update_user';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(update),
      );

      if (response.statusCode == 201) {
        return response.statusCode.toString();
      } else {
        print('Falha na requisição: ${response.statusCode}');
        return response.statusCode.toString();
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return '';
  }

  Future<Map<String, dynamic>> fetchInfoPatient(String token) async {
    String url = '${AppConstants.baseUrlApi}/usuarios/get_info';
    Map<String, dynamic> retornoNull = {};
    try {
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchInfoPatientEndereco(String token) async {
    String url = '${AppConstants.baseUrlApi}/usuarios/get_info_endereco';
    Map<String, dynamic> retornoNull = {};
    try {
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);

        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchSetTokenFirebaseInApi(
      newRequest, userToken) async {
    String url = '${AppConstants.baseUrlApi}/usuarios/set_token_firebase';
    Map<String, dynamic> retornoNull = {};
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        },
        body: jsonEncode(newRequest),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }

  Future<Map<String, dynamic>> fetchSetTokenFirebasePhysician(
      newRequest, userToken) async {
    String url = '${AppConstants.baseUrlApi}/medicos/set_token_firebase';
    Map<String, dynamic> retornoNull = {};
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken
        },
        body: jsonEncode(newRequest),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        return responseData;
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (err) {
      print('Erro na requisição: $err');
    }
    return retornoNull;
  }
}
