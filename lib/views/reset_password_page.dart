
import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/reset_password_controller.dart';
import 'sign_In_page.dart';


class ResetPassPage extends StatefulWidget {
  final String email;

  const ResetPassPage({required this.email, Key? key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}


class _ResetPassState extends State<ResetPassPage>{
  
  final TextEditingController _codigo = TextEditingController();
  final TextEditingController _retypeNewPass = TextEditingController();
  final TextEditingController _newPass= TextEditingController();

  late String email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: !_isLoading,
            child: _buildForm(widget.email),
          ),
          if(_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }



  Widget _buildForm(String email){
  return ListView(
    padding: EdgeInsets.all(20),
    physics: const AlwaysScrollableScrollPhysics(),
    children: <Widget>[
      SizedBox(height: 100),
      SizedBox(
          width: 50,
          height: 30,
          child: Image.network('https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png'),
        ),
        const SizedBox(
          height: 30,
        ),
      const SizedBox(
        width: 60,
        height: 30,
        child: Text(
          'Redefinição de Senha',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      Container(
        width: 50,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
          'Um email foi enviado para:\n $email ',
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        ),
      ),
      const SizedBox(
        height: 10,     
      ),
      const SizedBox(
        width: 60,
        height: 100,
        child: Text(
          'Por favor, insira no campo abaixo o código que lhe foi fornecido via e-mail e redefina uma nova senha.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      TextFormField(
        controller: _codigo,
        decoration: const InputDecoration(
          labelText: "Codigo",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      const SizedBox(
        height: 10,     
      ),
      TextFormField(
        controller: _newPass,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Nova Senha",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      const SizedBox(
        height: 10,     
      ),
      TextFormField(
        controller: _retypeNewPass,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Repita a Nova Senha",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      const SizedBox(
        height: 50,
      ),
      ElevatedButton(
        onPressed: (){
          _setLoading(true);
          Timer(const Duration(seconds: 1), () {
            String code = _codigo.text;
            String newPass = _newPass.text;
            String retypeNewPass = _retypeNewPass.text;
            
            if (newPass == retypeNewPass) {
              resetPassword(code, newPass);
  
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            }else{
              _setLoading(false);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Text("As Senhas não coincidem"),
                  );
                },
              );
            }
  
          });
  
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
          minimumSize: const Size(70, 50)
        ),
        child: const Text(
          "Cadastrar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
}

