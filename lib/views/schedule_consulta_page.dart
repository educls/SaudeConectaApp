import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../controllers/consulta_controller.dart';
import '../controllers/horario_controller.dart';
import '../utils/class/Theme.dart';
import '../utils/date_formater.dart';
import '../utils/gera_string.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScheduleConsulta extends StatefulWidget {
  const ScheduleConsulta(
      {required this.dropdownOptionsEspecialidade,
      required this.userToken,
      Key? key,
      required this.medInfos})
      : super(key: key);

  final Map<String, dynamic> dropdownOptionsEspecialidade;
  final Map<String, dynamic> medInfos;
  final String userToken;
  @override
  _ScheduleConsultaState createState() => _ScheduleConsultaState();
}

class _ScheduleConsultaState extends State<ScheduleConsulta> {
  DateTime _selectedDate = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RandomStringGenerator generator = RandomStringGenerator();

  DateFormatter dateFormatter = DateFormatter();
  late String userToken;
  final ValueNotifier<String> _dropValue = ValueNotifier<String>('');
  final ValueNotifier<String> dropValueDoctor = ValueNotifier<String>('');
  final ValueNotifier<String> dropValueHours = ValueNotifier<String>('');

  late Map<String, dynamic> medInfos;
  Map<String, String> dropdownOptionsDoutor = {};
  Map<String, dynamic> returnHorarios = {};

  Map<String, dynamic> dropdownOptionsEspecialidade = {};
  Map<String, String> dropdownOptionsHoursBackup = {};
  Map<String, String> dropdownOptionsHours = {
    '07:30:00': '07:30',
    '08:00:00': '08:00',
    '08:30:00': '08:30',
    '09:00:00': '09:00',
    '09:30:00': '09:30',
    '10:00:00': '10:00',
    '10:30:00': '10:30',
    '11:00:00': '11:00',
    '13:00:00': '13:00',
    '13:30:00': '13:30',
    '14:00:00': '14:00',
    '14:30:00': '14:30',
    '15:00:00': '15:00',
    '15:30:00': '15:30',
    '16:00:00': '16:00',
    '16:30:00': '16:30',
    '17:00:00': '17:00',
    '17:30:00': '17:30',
  };

  @override
  void initState() {
    super.initState();
    userToken = widget.userToken;
    medInfos = widget.medInfos;
    dropdownOptionsEspecialidade = widget.dropdownOptionsEspecialidade;
    dropdownOptionsHoursBackup = Map.from(dropdownOptionsHours);

    print(medInfos);
  }

  void _setNomeDropDown(choice) {
    print(dropdownOptionsEspecialidade);
    setState(() {
      dropdownOptionsDoutor = {};
      for (var medico in medInfos['medicoInfos']) {
        if (medico['Especialidade'] == choice) {
          dropdownOptionsDoutor[medico['ID_Medico'].toString()] =
              'Dr. ${medico['Nome']}';
        }
      }
    });
  }

  void _setHorariosDropDown() async {
    String data = dateFormatter
        .formatToYYYYMMDD(dateFormatter.convertToDateTime('$_selectedDate'));
    String idMedico = dropValueDoctor.value;

    returnHorarios = await buscaHorariosDisponiveis(data, idMedico);
    setState(() {
      dropdownOptionsHours = Map.from(dropdownOptionsHoursBackup);

      for (var horario in returnHorarios['horariosAgendados']) {
        var horaAgendada = horario['HoraConsulta'].toString();
        if (dropdownOptionsHours.containsKey(horaAgendada)) {
          dropdownOptionsHours.remove(horaAgendada);
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(20101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      _setHorariosDropDown();
    }
  }

  bool _isLoading = false;
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )
        ),
        title: const Text(
          'Agendar Consulta',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? const Color.fromARGB(255, 35, 35, 36)
            : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Stack(
        children: [
          _isLoading == false
              ? _buildFormConsulta()
              : const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  Widget _buildFormConsulta() {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: AnimationLimiter(
              child: Column(
            children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 260,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://raw.githubusercontent.com/educls/arquivos/main/logo_saude_conecta.png",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Especialidade',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ValueListenableBuilder<String>(
                        valueListenable: _dropValue,
                        builder: (BuildContext context, String value, _) {
                          return DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Selecione uma Opção"),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (choice) => {
                              _dropValue.value = choice.toString(),
                              _setNomeDropDown(dropdownOptionsEspecialidade[
                                  choice.toString()]),
                              print(dropdownOptionsEspecialidade[
                                  choice.toString()])
                            },
                            onTap: () {
                              setState(() {
                                dropValueDoctor.value = '';
                                dropValueHours.value = '';
                                _selectedDate = DateTime.now();
                              });
                            },
                            items: dropdownOptionsEspecialidade.keys
                                .map((String op) {
                              return DropdownMenuItem<String>(
                                value: op,
                                child: Text(dropdownOptionsEspecialidade[op]!),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Doutor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ValueListenableBuilder<String>(
                        valueListenable: dropValueDoctor,
                        builder: (BuildContext context, String value, _) {
                          return DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Selecione uma Opção"),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (choice) => {
                              dropValueDoctor.value = choice.toString(),
                            },
                            onTap: () {
                              setState(() {
                                dropValueHours.value = '';
                                _selectedDate = DateTime.now();
                              });
                            },
                            items: dropdownOptionsDoutor.keys.map((String op) {
                              return DropdownMenuItem<String>(
                                value: op,
                                child: Text(dropdownOptionsDoutor[op]!),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                  const SizedBox(height: 50),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Disponibilidade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: dateFormatter
                            .formatToDDMMYYYY(_selectedDate.toLocal())
                            .split(' ')[0],
                      ),
                      onTap: () {
                        _selectDate(context);
                        setState(() {
                          dropValueHours.value = '';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Data',
                        hintText: 'Selecione a data',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Horario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ValueListenableBuilder<String>(
                        valueListenable: dropValueHours,
                        builder: (BuildContext context, String value, _) {
                          return DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Selecione um Horario"),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (choice) => {
                              dropValueHours.value = choice.toString(),
                            },
                            items: dropdownOptionsHours.keys.map((String op) {
                              return DropdownMenuItem<String>(
                                value: op,
                                child: Text(dropdownOptionsHours[op]!),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () async {
                      _setLoading(true);

                      String idMedico = dropValueDoctor.value;
                      String especialidade =
                          dropdownOptionsEspecialidade![_dropValue.value]
                              .toString();
                      String data =
                          dateFormatter.formatToDDMMYYYY(_selectedDate);
                      String dataFormatDB =
                          dateFormatter.formatToYYYYMMDD(data);
                      String hora = dropValueHours.value;

                      bool response = await cadastraConsulta(idMedico,
                          especialidade, dataFormatDB, hora, userToken);

                      Timer(const Duration(milliseconds: 200), () async {
                        if (response) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Consulta Agendada'),
                                content: Text(
                                    '$especialidade \nData: $data \nHora: $hora'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      _setLoading(false);
                                    },
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Erro ao Agendar Consulta'),
                                );
                              });
                        }
                      });
                      _dropValue.value = '';
                      dropValueDoctor.value = '';
                      _selectedDate = DateTime.now();
                      dropValueHours.value = '';
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(75, 57, 239, 1),
                        minimumSize: const Size(350, 50)),
                    child: const Text(
                      'Agendar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
          )),
        ));
  }
}
