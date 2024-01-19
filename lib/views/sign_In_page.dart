import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/patient_controller.dart';
import '../controllers/physician_controller.dart';
import '../utils/class/Theme.dart';
import 'homePage.dart';
import 'password_recovery_page.dart';
import 'sign_Up_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _switchChangeTypeAccount = false;
  bool _switchTheme = true;

  final TextEditingController _user = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  final TextEditingController _crm = TextEditingController();
  final TextEditingController _passPhy = TextEditingController();
  bool _isLoading = false;
  String tipo = '';

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: _isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          if (!_isLoading && !_switchChangeTypeAccount)
            _buildForm(),
          if (!_isLoading && _switchChangeTypeAccount)
            _buildFormPhysician(),
        ],
      ),
  );
}


  
  Widget _buildForm(){
    return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const SizedBox(height: 120),
            SizedBox(
              width: 50,
              height: 30,
              child: Image.network('https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png'),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              autofocus: _isLoading,
              keyboardType: TextInputType.emailAddress,
              controller: _user,
              decoration: const InputDecoration(
                labelText: "E-mail",
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
            TextFormField(
              autofocus: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: _pass,
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecoveryPassPage()),
                );
              },
              child: const Text(
                'Recuperar Senha',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SwitchListTile(
                title: const Text("Paciente || Medico"),
                value: _switchChangeTypeAccount,
                onChanged: (bool value) {
                  setState(() {
                    _switchChangeTypeAccount = value;
                    print(_switchChangeTypeAccount);
                  });
                }
            ),
              const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                _setLoading(true);
                print(_isLoading);
        
                Timer(const Duration(milliseconds: 1000), () async{
                  String username = _user.text;
                  String password = _pass.text;
        
                  String userToken = await patientLogin(username, password);
                  tipo = 'paciente';
        
                  bool loadingEnd = returFalse();
                  _setLoading(!loadingEnd);
                  print(_isLoading);
                
                  if(userToken.length > 30){
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(userToken: userToken, tipo: tipo)
                      ),
                    );
                  }else{
                    _setLoading(loadingEnd);
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Text("Login Invalido"),
                        );
                      },
                    );
                  }
                });
                  
        
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                minimumSize: const Size(10, 60),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text(
                'Não possue conta? Cadastre-se',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Escuro || Claro"),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
                    child: SwitchListTile(
                      value: _switchTheme,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 140),
                      onChanged: (bool value) {
                        setState(() {
                          _switchTheme = value;
                        });
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }


  Widget _buildFormPhysician(){
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
                height: 50,
              ),
              TextFormField(
                autofocus: _isLoading,
                keyboardType: TextInputType.number,
                controller: _crm,
                decoration: const InputDecoration(
                  labelText: "CRM",
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
              TextFormField(
                autofocus: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                controller: _passPhy,
                decoration: const InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),const SizedBox(height: 50),
              SwitchListTile(
                  title: const Text("Paciente || Medico"),
                  value: _switchChangeTypeAccount,
                  onChanged: (bool value) {
                    setState(() {
                      _switchChangeTypeAccount = value;
                    });
                  }
                ),
                const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  _setLoading(true);
                  print(_isLoading);

                  Timer(const Duration(milliseconds: 1000), () async{
                    String username = _crm.text;
                    String password = _passPhy.text;

                    String userToken = await physicianLogin(username, password);
                    tipo = 'medico';

                    bool loadingEnd = returFalse();
                    _setLoading(!loadingEnd);
                    print(_isLoading);
                  
                    if(userToken.length > 30){
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userToken: userToken, tipo: tipo)
                        ),
                      );
                    }else{
                      _setLoading(loadingEnd);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Text("Login Invalido"),
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
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
