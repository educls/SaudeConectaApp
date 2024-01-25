

import 'package:flutter_application_1/services/chat_service.dart';

FetchApiMessages fetchApiMessages = FetchApiMessages();

Future<Map<String, dynamic>> getMensagensConsulta(String userToken) async {
  
  Map<String, dynamic> response = await fetchApiMessages.fetchMessages(userToken);

  return response;
}