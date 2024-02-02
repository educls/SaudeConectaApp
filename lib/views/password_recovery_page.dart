import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/patient_controller.dart';
import 'reset_password_page.dart';

class RecoveryPassPage extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Visibility(
            visible: !_isLoading,
            child: _buildForm(),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 70),
          SizedBox(
            width: 50,
            height: 30,
            child: Image.network(
                'https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png'),
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: Text("Digite o email de recuperação"),
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
            onPressed: () async {
              _setLoading(true);
              String email = _email.text;

              if (email.isEmpty) {
                await Future.delayed(const Duration(milliseconds: 500));

                _setLoading(false);
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Text("O Campo Vazio"),
                    );
                  },
                );
              } else {
                String response = await patientSendCodeEmail(email);
                _setLoading(false);
                print(response);

                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPassPage(email: email)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                minimumSize: const Size(70, 50)),
            child: const Text(
              "Enviar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
