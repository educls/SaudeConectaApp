
import '../models/reset_password_model.dart';
import '../services/reset_password_service.dart';

FetchApiResetPassword fetchApiResetPassword = FetchApiResetPassword();

bool resetPassword(String code, String password){

  ResetPassModel newPassword = ResetPassModel(code: code, password: password);

  fetchApiResetPassword.fetchResetPassword(newPassword);

  return false;
}