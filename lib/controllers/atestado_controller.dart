
import '../models/change_state_schedule.dart';
import '../models/pop_up_model_atestado.dart';
import '../services/atestado_service.dart';
import '../utils/date_formater.dart';

FetchApiAtestados fetchApiAtestados = FetchApiAtestados();

Map<String, String> atestadoEmitir(PopUpModelForPhysician newAtestado, String documentPdf, String userToken){
  Map<String, String> retornoNull = {};
  DateFormatter dateFormatter = DateFormatter();

  AtestadoPdfModel novoAtestadoComPdf = AtestadoPdfModel(
    idPaciente: newAtestado.idPaciente,
    dataEmissao: dateFormatter.formatToYYYYMMDD(newAtestado.dataConsulta), 
    especialidade: newAtestado.especialidade, 
    documentPdf: documentPdf
  );
  
  fetchApiAtestados.fetchEmitirAtestadoPdf(novoAtestadoComPdf, userToken);

  return retornoNull;
}

Future<Map<String, dynamic>> getAtestados(String userToken)async {

  Map<String, dynamic> response = await fetchApiAtestados.fetchAtestados(userToken);

  return response;
}