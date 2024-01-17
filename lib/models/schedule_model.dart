class ScheculeModel {
  String idMedico;
  String especialidade;
  String data;
  String hora;

  ScheculeModel({
    required this.idMedico,
    required this.especialidade,
    required this.data,
    required this.hora,
  });

  Map<String, dynamic> toJson() {
    return {
      'ID_Medico': idMedico,
      'Especialidade': especialidade,
      'DataConsulta': data,
      'HoraConsulta': hora,
    };
  }
}