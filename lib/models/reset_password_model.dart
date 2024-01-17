class ResetPassModel {
  String code;
  String password;

  ResetPassModel({
    required this.code,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'password': password,
    };
  }
}