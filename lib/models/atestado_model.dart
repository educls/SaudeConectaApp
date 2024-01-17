class AtestadoMedicoModel {
  String nomeMedico;
  String crm;
  String nomePaciente;
  String data;
  String motivo;
  String diasAfastamento;
  String cidade;
  String estado;

  AtestadoMedicoModel({
    required this.nomeMedico,
    required this.crm,
    required this.nomePaciente,
    required this.data,
    required this.motivo,
    required this.diasAfastamento,
    required this.cidade,
    required this.estado,
  });
}