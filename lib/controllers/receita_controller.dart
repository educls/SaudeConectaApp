
import '../models/pop_up_model_atestado.dart';
import '../models/receita_medica_model.dart';
import '../services/receita_service.dart';
import '../utils/date_formater.dart';

FetchApiReceitas fetchApiReceitas = FetchApiReceitas();

Map<String, String> receitaEmitir(PopUpModelForPhysician newAtestado, String documentTextPdf, String userToken){
  Map<String, String> retornoNull = {};
  DateFormatter dateFormatter = DateFormatter();

  ReceitaPdfModel novaReceita = ReceitaPdfModel(
    idPaciente: newAtestado.idPaciente,
    dataEmissao: dateFormatter.formatToYYYYMMDD(newAtestado.dataConsulta),
    especialidade: newAtestado.especialidade,
    documentTextPdf: documentTextPdf,
    tipo: 'Receita'
  );

    fetchApiReceitas.fetchEmitirReceitaPdf(novaReceita, userToken);

  return retornoNull;
}

Future<Map<String, dynamic>> getReceitas(String userToken) async{

  Map<String, dynamic> response = await fetchApiReceitas.fetchReceitas(userToken);

  return response;
}