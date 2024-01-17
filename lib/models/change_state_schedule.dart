
class ChangeStateScheduleModel {
  String idConsulta;
  String state;

  ChangeStateScheduleModel({
    required this.idConsulta,
    required this.state,
  });

  Map<String, dynamic> toJson(){
    return{
      'ID_Consulta': idConsulta,
      'Estado': state,
    };
  }
}

class AtestadoPdfModel{
  String idPaciente;
  String dataEmissao;
  String especialidade;
  String documentPdf;

  AtestadoPdfModel({
    required this.idPaciente,
    required this.dataEmissao,
    required this.especialidade,
    required this.documentPdf,
  });

  Map<String, dynamic> toJson(){
    return{
      'ID_Paciente': idPaciente,
      'DataEmissao': dataEmissao,
      'Especialidade': especialidade,
      'arquivo': documentPdf,
    };
  }
}