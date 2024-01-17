class ReceitaMedicaModel {
  String nomeMedico;
  String crm;
  String nomePaciente;
  String data;
  String medicamentoNome;
  String medicamentoDozagem;
  String receitaValidade;
  String obs;

  ReceitaMedicaModel({
    required this.nomeMedico,
    required this.crm,
    required this.nomePaciente,
    required this.data,
    required this.medicamentoNome,
    required this.medicamentoDozagem,
    required this.receitaValidade,
    required this.obs,
  });
}

class ReceitaPdfModel{
  String idPaciente;
  String dataEmissao;
  String especialidade;
  String documentTextPdf;
  String tipo;

  ReceitaPdfModel({
    required this.idPaciente,
    required this.dataEmissao,
    required this.especialidade,
    required this.documentTextPdf,
    required this.tipo,
  });

  Map<String, dynamic> toJson(){
    return{
      'ID_Paciente': idPaciente,
      'DataEmissao': dataEmissao,
      'Especialidade': especialidade,
      'arquivo': documentTextPdf,
      'tipo': tipo,
    };
  }
}