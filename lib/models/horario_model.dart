class HorarioModel{
  String data;
  String idMedico;

  HorarioModel({
    required this.data,
    required this.idMedico,
  });

  Map<String, dynamic> toJson(){
    return{
      'Data': data,
      'idMedico': idMedico,
    };
  }
}