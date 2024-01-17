class PatientModel {
  String nome;
  String email;
  String senha;
  String cpf;
  String telefone;
  Endereco endereco;

  PatientModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    required this.telefone,
    required this.endereco,
  });

  Map<String, dynamic> toJson() {
    return {
      'Nome': nome,
      'Email': email,
      'Senha': senha,
      'CPF': cpf,
      'Telefone': telefone,
      'Endereco': endereco.toJson(),
    };
  }
}

class Endereco {
  String estado;
  String cidade;
  String bairro;
  String rua;
  String numero;

  Endereco({
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.rua,
    required this.numero,
  });

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'cidade': cidade,
      'bairro': bairro,
      'rua': rua,
      'numero': numero,
    };
  }
}

class EmailSendCode {
  String email;

  EmailSendCode({
    required this.email,
  });

  Map<String, dynamic> toJson(){
    return{
      'email': email,
    };
  }
}

class LoginModel {
  String email;
  String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson(){
    return{
      'email': email,
      'password': password,
    };
  }
}

