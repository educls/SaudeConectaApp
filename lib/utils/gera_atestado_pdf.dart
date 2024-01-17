

import '../models/atestado_model.dart';
import '../models/receita_medica_model.dart';


String gerarAtestadoPdf(AtestadoMedicoModel newAtestado) {
  String atestado = """\n
    \n
      ATESTADO MÉDICO\n
    \n
    Eu, ${newAtestado.nomeMedico}, CRM ${newAtestado.crm}, atesto para os devidos \n
    fins que o(a) paciente ${newAtestado.nomePaciente}, esteve sob \n
    meus cuidados médicos na data de ${newAtestado.data}, \n
    apresentando ${newAtestado.motivo}. \n
    \n
    Durante este período, o paciente necessitou de repouso/afastamento \n
    de suas atividades habituais/temporária/isenção de atividades que \n
    possam comprometer sua saúde, pelo período de ${newAtestado.diasAfastamento} dias, \n
    a contar a partir da data deste atestado.\n
    \n
    Qualquer dúvida, estou à disposição para esclarecimentos. \n
    \n
    Local: ${newAtestado.cidade}, ${newAtestado.estado} \n
    Data: ${newAtestado.data}\n
    \n
  """;

  return atestado;

}

String gerarReceitaPdf(ReceitaMedicaModel novaReceita){
  String receita = """\n
    \n
    RECEITA MÉDICA\n
    \n
    Paciente: ${novaReceita.nomePaciente}\n
    Data: ${novaReceita.data}\n
    \n
    Medicamentos:\n
    1. ${novaReceita.medicamentoNome} - ${novaReceita.medicamentoDozagem}\n
    2.\n
    3.\n
    4.\n
    \n
    Observações:\n
    ${novaReceita.obs}\n
    \n
    Validade: ${novaReceita.receitaValidade}\n
    \n
    Assinatura do Médico:   ${novaReceita.nomeMedico}\n
    CRM: ${novaReceita.crm}\n
    \n
    \n
    """;

  return receita;
}
