// lib/services/financial_planning_service.dart
import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';

import '../models/caixinha.dart';
import '../models/financial_planning.dart';


class FinancialPlanningService {
  final ApiBaseClient _client;

  FinancialPlanningService(this._client);

  Future<FinancialPlanning> createTemplate503020() async {
    // 1. Cria o template no DRF
    final resp = await _client.post(
      'planejamento/template/',
      body: jsonEncode({
        'nome': '50-30-20',
        'descricao': 'O método 50-30-20 divide a renda em 50% para necessidades, 30% para desejos e 20% para poupança ou investimentos.',
      }),
    );
    if (resp.statusCode != 201) {
      throw Exception('Erro criando template: ${resp.statusCode} ${resp.body}');
    }
    final planningJson = jsonDecode(resp.body);

    // 2. Busca as caixinhas para o usuário
    final listaResp = await _client.get('planejamento/caixinha/');
    if (listaResp.statusCode != 200) {
      throw Exception('Erro ao buscar caixinhas: ${listaResp.statusCode} ${listaResp.body}');
    }
    final List<dynamic> data = jsonDecode(listaResp.body);
    final caixinhas = data
        .map((e) => Caixinha.fromJson(e as Map<String, dynamic>))
        .toList();

    // 3. Monta e retorna o objeto completo
    return FinancialPlanning.fromJson(planningJson, caixinhas);
  }
}
