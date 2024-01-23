import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/edit_user_page.dart';
import 'package:provider/provider.dart';

import '../utils/class/Theme.dart';
import '../views/settings_page.dart';
import '../controllers/consulta_controller.dart';
import '../controllers/patient_controller.dart';
import '../controllers/physician_controller.dart';
import '../models/pop_up_model_atestado.dart';
import '../utils/date_formater.dart';
import '../utils/gera_string.dart';
import 'atestado_page.dart';
import 'get_atestados_page.dart';
import 'get_receitas_page.dart';
import 'medicamentos_page.dart';
import 'receita_medica_page.dart';
import 'schedule_consulta_page.dart';
import 'sign_In_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  final String userToken;
  final String tipo;
  const HomePage({required this.userToken, Key? key, required this.tipo})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RandomStringGenerator generator = RandomStringGenerator();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String userToken;
  late String tipo;
  Map<String, dynamic> userInfos = {};
  Map<String, dynamic> consultas = {};
  late Map<String, dynamic> consultasThrow = {"a": ''};
  Map<String, String> dropdownOptionsEspecialidade = {};
  DateFormatter dateFormatter = DateFormatter();

  Map<String, dynamic> fetchConsultasAgendadas = {};

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;
    tipo = widget.tipo;

    reloadConsultas();

    print("tipo: $tipo");
  }

  Future<void> _buscarInfos(String userToken, String tipo) async {
    if (tipo == 'paciente') {
      userInfos = await getInfosUserPatient(userToken);

      _setUser(userInfos['usuarioInfos']['Nome'],
          userInfos['usuarioInfos']['Email'], ' ');

      fetchConsultasAgendadas = await getConsultasPatient(userToken);
    } else {
      userInfos = await getInfosUserPhysician(userToken);

      _setUser(userInfos['medicoInfos']['Nome'], ' ',
          userInfos['medicoInfos']['Especialidade']);

      fetchConsultasAgendadas = await getConsultasPhysician(userToken);
    }
  }

  Future<void> reloadConsultas() async {
    _setLoading(true);
    await _buscarInfos(userToken, tipo);
    _setConsultas(fetchConsultasAgendadas);
    Timer(const Duration(milliseconds: 500), () {
      _setLoading(false);
    });
  }

  void _onRefresh() async {
    _buscarInfos(userToken, tipo);

    await Future.delayed(const Duration(milliseconds: 1000));
    _setLoading(true);
    _setConsultas(fetchConsultasAgendadas);
    Timer(const Duration(milliseconds: 100), () {
      _setLoading(false);
    });

    _refreshController.refreshCompleted();
  }

  void _setConsultas(_consultas) {
    setState(() {
      consultas = _consultas;
    });
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  String _name = 'nome';
  String _email = 'email';
  String _especialidade = ' ';
  void _setUser(String name, String email, String especialidade) {
    setState(() {
      _name = name;
      _email = email;
      _especialidade = especialidade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Consultas Agendadas'),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: tipo == "paciente"
          ? _buildDrawer(widget.userToken)
          : _buildDrawerPhysician(widget.userToken),
      body: Stack(
        children: [
          (_isLoading == true)
              ? const Center(child: CircularProgressIndicator())
              : _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Scaffold(
      body: (consultas == {} || consultas!['consultas'] == null)
          ? const Center(child: CircularProgressIndicator())
          : AnimationLimiter(
              child: SmartRefresher(
                enablePullDown: true,
                header: WaterDropMaterialHeader(
                  color: Colors.white,
                  backgroundColor:
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? const Color.fromARGB(255, 35, 35, 36)
                          : const Color.fromARGB(255, 54, 158, 255),
                ),
                footer: const ClassicFooter(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: (consultas!['consultas'].isEmpty)
                    ? _widgetConsultasIsEmpty()
                    : ListView.builder(
                        itemCount: consultas!['consultas'].length,
                        itemBuilder: (BuildContext context, int index) {
                          final consulta = consultas['consultas'][index];
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: (consulta['Estado'] == 'Finalizada')
                                        ? (Provider.of<ThemeProvider>(context)
                                                .isDarkMode
                                            ? const Color.fromARGB(
                                                255, 76, 76, 77)
                                            : const Color.fromARGB(
                                                255, 131, 194, 253))
                                        : null,
                                    elevation: 8,
                                    margin: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text((tipo == 'paciente')
                                          ? '${consulta['Especialidade']} \n ${dateFormatter.convertToDateTime(consulta['DataConsulta'])} \n ${consulta['HoraConsulta']}'
                                          : 'Paciente: ${consulta['NomePaciente']} \n ${dateFormatter.convertToDateTime(consulta['DataConsulta'])} \n ${consulta['HoraConsulta']}'),
                                      trailing: Text(
                                        'Estado: \n${consulta['Estado']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      onTap: () async {
                                        if (tipo == 'paciente') {
                                          // PopUpModelForPacient newSchedule = PopUpModelForPacient(
                                          //   idConsulta: consulta['ID_Consulta'].toString(),
                                          //   idPaciente: consulta['ID_Paciente'].toString(),
                                          //   idMedico: consulta['ID_Medico'].toString(),
                                          //   especialidade: consulta['Especialidade'],
                                          //   dataConsulta: dateFormatter.convertToDateTime(consulta['DataConsulta']),
                                          //   horaConsulta: consulta['HoraConsulta']
                                          // );

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    consulta['Especialidade']),
                                                content: Text(
                                                    'Data: ${dateFormatter.convertToDateTime(consulta['DataConsulta'])} \nHora: ${consulta['HoraConsulta']}'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      _setLoading(true);
                                                      Navigator.of(context)
                                                          .pop();
                                                      var response =
                                                          await deleteConsulta(
                                                              userToken,
                                                              consulta[
                                                                      'ID_Consulta']
                                                                  .toString());

                                                      if (response == '200') {
                                                        reloadConsultas();
                                                      }
                                                    },
                                                    child:
                                                        const Text('Excluir'),
                                                  ),
                                                  Card(
                                                    elevation: 2,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Voltar'),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          PopUpModelForPhysician newAtestado =
                                              PopUpModelForPhysician(
                                                  idConsulta:
                                                      consulta['ID_Consulta']
                                                          .toString(),
                                                  idPaciente:
                                                      consulta['ID_Paciente']
                                                          .toString(),
                                                  nomePaciente:
                                                      consulta['NomePaciente'],
                                                  idMedico:
                                                      consulta['ID_Medico']
                                                          .toString(),
                                                  nomeMedico:
                                                      consulta['NomeMedico'],
                                                  especialidade:
                                                      consulta['Especialidade'],
                                                  dataConsulta: dateFormatter
                                                      .convertToDateTime(
                                                          consulta[
                                                              'DataConsulta']),
                                                  horaConsulta:
                                                      consulta['HoraConsulta']);

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    newAtestado.nomePaciente),
                                                content: Text(
                                                    'Data: ${newAtestado.dataConsulta} \nHora: ${newAtestado.horaConsulta}'),
                                                actions: [
                                                  Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Card(
                                                            elevation: 2,
                                                            child: TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => AtestadoPage(
                                                                          newAtestado:
                                                                              newAtestado,
                                                                          userToken:
                                                                              userToken)),
                                                                );
                                                              },
                                                              child: const Text(
                                                                  'Atestar'),
                                                            ),
                                                          ),
                                                          Card(
                                                            elevation: 2,
                                                            child: TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => ReceitaMedicaPage(
                                                                          newAtestado:
                                                                              newAtestado,
                                                                          userToken:
                                                                              userToken)),
                                                                );
                                                              },
                                                              child: const Text(
                                                                  'Receitar'),
                                                            ),
                                                          ),
                                                          Card(
                                                            elevation: 2,
                                                            child: TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Voltar'),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Card(
                                                        elevation: 8,
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Tem Certeza?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        String
                                                                            estado =
                                                                            'Finalizada';

                                                                        await changeSateConsulta(
                                                                            consulta['ID_Consulta'].toString(),
                                                                            estado,
                                                                            userToken);

                                                                        // ignore: use_build_context_synchronously
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        reloadConsultas();
                                                                      },
                                                                      child: const Text(
                                                                          'Sim'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Não'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: const Text(
                                                              'Finalizar Consulta'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
              ),
            ),
    );
  }

  Widget _buildDrawer(String userToken) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 72, 131), Colors.lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          print(userInfos);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditUserPage(
                                    userInfos: userInfos,
                                    userToken: userToken)),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.white,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _email == " " ? _especialidade : _email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: const Text('Agendar Consulta'),
            onTap: () async {
              Map<String, dynamic> medicos = await getPhysicians();

              for (var medico in medicos['medicoInfos']) {
                if (!dropdownOptionsEspecialidade
                    .containsValue(medico['Especialidade'])) {
                  dropdownOptionsEspecialidade[generator.getRandomString(5)] =
                      '${medico['Especialidade']}';
                }
              }

              Navigator.of(context).pop();
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScheduleConsulta(
                        dropdownOptionsEspecialidade:
                            dropdownOptionsEspecialidade,
                        userToken: userToken,
                        medInfos: medicos)),
              );
            },
          ),
          ListTile(
            title: const Text('Receitas Médicas'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GetReceitasPage(userToken: userToken)),
              );
            },
          ),
          ListTile(
            title: const Text('Atestados'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GetAtestadosPage(userToken: userToken)),
              );
            },
          ),
          ListTile(
            title: const Text('Opção 3'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Expanded(
                  child: Text('Logout'),
                ),
                Icon(Icons.exit_to_app),
              ],
            ),
            onTap: () {
              _setLoading(true);
              Navigator.of(context).pop();
              Timer(const Duration(milliseconds: 500), () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                  (route) => false,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _widgetConsultasIsEmpty() {
    return const Center(
      child: Text(
        'Não há consultas cadastradas.',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildDrawerPhysician(String userToken) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 72, 131), Colors.lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  _name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _especialidade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Medicamentos'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MedicamentosPage(userToken: userToken)),
                  );
                },
              ),
              ListTile(
                title: const Text('Opção 2'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Opção 3'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Expanded(
                      child: Text('Logout'),
                    ),
                    Icon(Icons.exit_to_app),
                  ],
                ),
                onTap: () {
                  _setLoading(true);
                  Navigator.of(context).pop();
                  Timer(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                      (route) => false,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
