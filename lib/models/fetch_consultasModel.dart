class FetchConsultaModel {
  final int id;
  final int idPaciente;
  final int idMedico;
  final String especialidade;
  final DateTime dataConsulta;
  final String horaConsulta;
  final String estado;

  FetchConsultaModel({
    required this.id,
    required this.idPaciente,
    required this.idMedico,
    required this.especialidade,
    required this.dataConsulta,
    required this.horaConsulta,
    required this.estado,
  });
}