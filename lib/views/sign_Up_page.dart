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

  late List<String> campos;
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
    return SingleChildScrollView(
      child: AnimationLimiter(
          child: Column(
        children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: 260,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SwitchListTile(
                    title: const Text("Medico || Paciente"),
                    value: _switchChangeStateAccount,
                    onChanged: (bool value) {
                      setState(() {
                        _switchChangeStateAccount = value;
                        print(_switchChangeStateAccount);
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
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
              ),
              Visibility(
                visible: _switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
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
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
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
              ),
              Visibility(
                visible: _switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 50),
                    const Text("Endereço"),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
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

                              _setPreenchido(false);
                            },
                            child: const Text("Preencher"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Visibility(
                visible: !_switchChangeStateAccount,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 40)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  _setLoading(true);
                  await Future.delayed(const Duration(milliseconds: 1000));
                  if (_switchChangeStateAccount == true) {
                    campos = [
                      _user.text,
                      _email.text,
                      _pass.text,
                      _cpf.text,
                      _tel.text,
                      _estate.text,
                      _city.text,
                      _district.text,
                      _street.text,
                      _number.text
                    ];
                  } else {
                    campos = [
                      _user.text,
                      _pass.text,
                      _cpf.text,
                      _crm.text,
                      _speciality.text,
                    ];
                  }

                  if (campos.any((campo) => campo.isEmpty)) {
                    _setLoading(false);
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Text("Um dos campos está vazio"),
                        );
                      },
                    );
                  } else {
                    Timer(const Duration(seconds: 1), () async {
                      if (_switchChangeStateAccount == true) {
                        String response = await cadastraPatient(
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
                        print(response);
                        _setLoading(false);
                      } else {
                        String response = await cadastraPhysician(_user.text,
                            _pass.text, _cpf.text, _crm.text, _speciality.text);
                        print(response);
                        _setLoading(false);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                    minimumSize: const Size(350, 55)),
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
            ]),
      )),
    );
  }
}
