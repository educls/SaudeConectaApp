class MedicamentoModel {
  String nomeMedicamento;
  String formaFarmaceutica;
  String fabricante;
  String dataFabricacao;
  String dataValidade;
  String prescricaoMedica;
  String estoque;

  MedicamentoModel({
    required this.nomeMedicamento,
    required this.formaFarmaceutica,
    required this.fabricante,
    required this.dataFabricacao,
    required this.dataValidade,
    required this.prescricaoMedica,
    required this.estoque,
  });

  Map<String, dynamic> toJson() {
    return {
      "Nome_Medicamento": nomeMedicamento,
      "Forma_Farmaceutica": formaFarmaceutica,
      "Fabricante": fabricante,
      "Data_Fabricacao": dataFabricacao,
      "Data_Validade": dataValidade,
      "Prescricao_Medica": prescricaoMedica,
      "Estoque": estoque
    };
  }
}
