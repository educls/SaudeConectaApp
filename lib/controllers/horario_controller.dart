

import '../models/horario_model.dart';
import '../services/horario_service.dart';

Future<Map<String, dynamic>> buscaHorariosDisponiveis(String data, String idMedico)async {
  Map<String, String> retornoNull = {};

  try{
    HorarioModel newSearchHorario = HorarioModel(data: data, idMedico: idMedico);

    Map<String, dynamic> retorno = await fetchHorariosDisponiveis(newSearchHorario);

    return retorno;
  }catch(err){
    return retornoNull;
  }
}