



import '../services/chat_service.dart';

FetchApiMessages fetchApiMessages = FetchApiMessages();

Future<Map<String, dynamic>> getMensagensConsulta(String userToken, String idMensagem) async {
  
  Map<String, dynamic> response = await fetchApiMessages.fetchMessages(userToken, idMensagem);

  return response;
}