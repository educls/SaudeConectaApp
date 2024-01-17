class PopUpModelForPhysician {
  String idConsulta;
  String idPaciente;
  dynamic nomePaciente;
  String idMedico;
  String nomeMedico;
  String especialidade;
  String dataConsulta;
  String horaConsulta;

  PopUpModelForPhysician({
    required this.idConsulta,
    required this.idPaciente,
    required this.nomePaciente,
    required this.idMedico,
    required this.nomeMedico,
    required this.especialidade,
    required this.dataConsulta,
    required this.horaConsulta,
  });
}

class PopUpModelForPacient {
  String idConsulta;
  String idPaciente;
  String idMedico;
  String especialidade;
  String dataConsulta;
  String horaConsulta;

  PopUpModelForPacient({
    required this.idConsulta,
    required this.idPaciente,
    required this.idMedico,
    required this.especialidade,
    required this.dataConsulta,
    required this.horaConsulta,
  });
}