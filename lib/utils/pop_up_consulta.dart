import 'package:flutter/material.dart';

import '../controllers/consulta_controller.dart';
import '../models/pop_up_model_atestado.dart';
import '../views/atestado_page.dart';
import '../views/receita_medica_page.dart';

void exibirPopup(
    BuildContext context, String especialidade, String data, String hora) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Consulta Agendada'),
        content: Text('$especialidade \nData: $data \nHora: $hora'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}

Map<String, dynamic> exibirPopUpConsultasAgendadas(
    BuildContext context, PopUpModelForPacient newAtestado, String token) {
  Map<String, dynamic> retornoNull = {};
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(newAtestado.especialidade),
        content: Text(
            'Data: ${newAtestado.dataConsulta} \nHora: ${newAtestado.horaConsulta}'),
        actions: [
          TextButton(
            onPressed: () async {
              final response =
                  await deleteConsulta(token, newAtestado.idConsulta);

              Navigator.of(context).pop(true);
            },
            child: const Text('Excluir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Voltar'),
          ),
        ],
      );
    },
  );
  return retornoNull;
}

Map<String, dynamic> exibirPopUpConsultasAgendadasForMedico(
    BuildContext context, PopUpModelForPhysician newAtestado, String token) {
  Map<String, dynamic> retornoNull = {};

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(newAtestado.nomePaciente),
        content: Text(
            'Data: ${newAtestado.dataConsulta} \nHora: ${newAtestado.horaConsulta}'),
        actions: [
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AtestadoPage(
                                newAtestado: newAtestado,
                                userToken: token,
                                tokenFirebase: '')),
                      );
                    },
                    child: const Text('Atestar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceitaMedicaPage(
                                  newAtestado: newAtestado,
                                  userToken: token,
                                  tokenFirebase: '',
                                )),
                      );
                    },
                    child: const Text('Receitar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Voltar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Tem Certeza?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                String estado = 'Finalizada';

                                await changeSateConsulta(
                                    newAtestado.idConsulta, estado, token);

                                Navigator.of(context).pop();

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const Text('Sim'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Não'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Finalizar Consulta'),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  return retornoNull;
}
