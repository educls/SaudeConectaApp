class PhysicianModel {
  String nome;
  String senha;
  String cpf;
  String crm;
  String especialidade;

  PhysicianModel({
    required this.nome,
    required this.senha,
    required this.cpf,
    required this.crm,
    required this.especialidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'Nome': nome,
      'Senha': senha,
      'CPF': cpf,
      'CRM': crm,
      'Especialidade': especialidade,
    };
  }
}

class LoginModelPhysician {
  String crm;
  String password;

  LoginModelPhysician({
    required this.crm,
    required this.password,
  });

  Map<String, dynamic> toJson(){
    return{
      'CRM': crm,
      'Senha': password,
    };
  }
}
