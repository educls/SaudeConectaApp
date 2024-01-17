import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/patient_controller.dart';
import 'reset_password_page.dart';


class RecoveryPassPage extends StatefulWidget{
  const RecoveryPassPage({Key? key}) : super(key: key);

  @override
  _RecoveryPassState createState() => _RecoveryPassState();
}


class _RecoveryPassState extends State<RecoveryPassPage> {

  final TextEditingController _email = TextEditingController();
  bool _isLoading = false;

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Visibility(
              visible: !_isLoading,
              child: _buildForm(),
            ),
            if(_isLoading)
              const Center(
                child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildForm(){
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(9, 23, 47, 1),
        body: Container(
          padding: const EdgeInsets.only(
            top: 130,
            left: 20,
            right: 20,
          ),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 30,
                child: Image.network('https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Text(
                      "Digite o email de recuperação",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (){
                  _setLoading(true);

                  Timer(const Duration(seconds: 2), () {
                    String email = _email.text;

                    bool worked = patientSendCodeEmail(email);
                    _setLoading(worked);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassPage(email: email)
                      ),
                    );

                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                  minimumSize: const Size(70, 50)
                ),
                child: const Text(
                  "Enviar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}