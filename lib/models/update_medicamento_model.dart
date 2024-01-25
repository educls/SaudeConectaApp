class UpdateMedicamentoModel {
  String idMedicamento;
  String estoque;

  UpdateMedicamentoModel({
    required this.idMedicamento,
    required this.estoque,
  });

  Map<String, dynamic> toJson(){
    return{
      'ID_Medicamento': idMedicamento,
      'Estoque': estoque,
    };
  }
}