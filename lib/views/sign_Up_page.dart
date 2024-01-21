import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../controllers/cep_controller.dart';
import '../controllers/patient_controller.dart';
import '../controllers/physician_controller.dart';
import 'sign_In_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _cep = TextEditingController();

  final TextEditingController _user = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _estate = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _crm = TextEditingController();
  final TextEditingController _speciality = TextEditingController();
  bool _switchChangeStateAccount = true;
  bool _isLoading = false;

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  bool _isPreenchido = true;
  void _setPreenchido(bool isPreenchido) {
    setState(() {
      _isPreenchido = isPreenchido;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return SingleChildScrollView(
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ), 
            children: [
              const SizedBox(height: 70),
              SizedBox(
                width: 50,
                height: 30,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.visiblePassword,
                controller: _user,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: false,
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _pass,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.visiblePassword,
                controller: _cpf,
                decoration: const InputDecoration(
                  labelText: "CPF",
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
              SwitchListTile(
                  title: const Text("Medico || Paciente"),
                  value: _switchChangeStateAccount,
                  onChanged: (bool value) {
                    setState(() {
                      _switchChangeStateAccount = value;
                      print(_switchChangeStateAccount);
                    });
                  }),
              const SizedBox(
                height: 50,
              ),
              Visibility(
                visible: _switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cep,
                              decoration: const InputDecoration(
                                labelText: "CEP",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String cep = _cep.text;
                              Map<String, dynamic> adress =
                                  await getEnderecoFromApi(cep);

                              _estate.text = adress['uf'];
                              _city.text = adress['localidade'];
                              _district.text = adress['bairro'];
                              _street.text = adress['logradouro'];
                              _tel.text = '0${adress['ddd']}';

                              _setPreenchido(false);
                            },
                            child: const Text("Preencher"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text("Contato"),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _tel,
                      decoration: const InputDecoration(
                        labelText: "Telefone",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text("Endereço"),
                    TextFormField(
                      controller: _estate,
                      enabled: _isPreenchido,
                      decoration: const InputDecoration(
                        labelText: "Estado",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _city,
                      enabled: _isPreenchido,
                      decoration: const InputDecoration(
                        labelText: "Cidade",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _district,
                      enabled: _isPreenchido,
                      decoration: const InputDecoration(
                        labelText: "Bairro",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _street,
                      enabled: _isPreenchido,
                      decoration: const InputDecoration(
                        labelText: "Rua",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _number,
                      decoration: const InputDecoration(
                        labelText: "Numero",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Visibility(
                visible: !_switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _crm,
                      decoration: const InputDecoration(
                        labelText: "CRM",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _speciality,
                      decoration: const InputDecoration(
                        labelText: "Especialidade",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _setLoading(true);
                  Timer(const Duration(seconds: 1), () {
                    if (_switchChangeStateAccount == true) {
                      bool workedP = cadastraPatient(
                          _user.text,
                          _email.text,
                          _pass.text,
                          _cpf.text,
                          _tel.text,
                          _estate.text,
                          _city.text,
                          _district.text,
                          _street.text,
                          _number.text);
                      print(workedP);
                      _setLoading(workedP);
                    } else {
                      bool workedM = cadastraPhysician(_user.text, _pass.text,
                          _cpf.text, _crm.text, _speciality.text);
                      print(workedM);
                      _setLoading(workedM);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                    minimumSize: const Size(70, 50)),
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ]
          ),
        )
      ),
    );
  }
}
