import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';

import '../models/caixinha.dart';
import '../models/financial_planning.dart';

class FinancialPlanningService {
  final ApiBaseClient _client;

  FinancialPlanningService(this._client);

  /// Cria o template 50-30-20 e retorna o planejamento completo
  Future<FinancialPlanning> createTemplate503020() async {
    final resp = await _client.post(
      'planejamento/template/',
      body: jsonEncode({
        'nome': '50-30-20',
        'descricao':
            'O método 50-30-20 divide a renda em 50% para necessidades, 30% para desejos e 20% para poupança ou investimentos.',
      }),
    );
    if (resp.statusCode != 201) {
      throw Exception('Erro criando template: ${resp.statusCode} ${resp.body}');
    }
    // Após criar, buscar planejamento completo usando novo endpoint
    return await getExistingPlanning();
  }

  /// Busca o planejamento já existente completo via endpoint /planejamento/listar/
  Future<FinancialPlanning> getExistingPlanning() async {
    final resp = await _client.get('planejamento/listar/');
    if (resp.statusCode != 200) {
      throw Exception(
          'Erro ao buscar planejamento: ${resp.statusCode} ${resp.body}');
    }
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final planejamentoJson = body['planejamento'] as Map<String, dynamic>;
    final List<dynamic> caixinhasJson = body['caixinhas'] as List<dynamic>;
    final caixinhas = caixinhasJson
        .map((e) => Caixinha.fromJson(e as Map<String, dynamic>))
        .toList();
    return FinancialPlanning.fromJson(planejamentoJson, caixinhas);
  }

  Future<Ganho> adicionarGanho({
    required String nome,
    required double quantia,
  }) async {
    final resp = await _client.post(
      'planejamento/ganho/',
      body: jsonEncode({
        'nome': nome,
        'quantia': quantia,
      }),
    );
    if (resp.statusCode != 201) {
      throw Exception(
          'Erro ao adicionar ganho: ${resp.statusCode} ${resp.body}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return Ganho.fromJson(json);
  }

  Future<Gasto> adicionarGasto({
    required String nome,
    required double quantia,
    required int caixinhaId,
  }) async {
    final resp = await _client.post(
      'planejamento/gasto/',
      body: jsonEncode({
        'nome': nome,
        'quantia': quantia,
        'caixinha': caixinhaId,
      }),
    );
    if (resp.statusCode != 201) {
      throw Exception(
          'Erro ao adicionar gasto: ${resp.statusCode} ${resp.body}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return Gasto.fromJson(json);
  }

  Future<List<Caixinha>> listarCaixinhas() async {
    final resp = await _client.get('planejamento/caixinha/');
    if (resp.statusCode != 200) {
      throw Exception(
          'Erro ao listar caixinhas: ${resp.statusCode} ${resp.body}');
    }
    final body = jsonDecode(resp.body);
    if (body is List) {
      return body
          .map((json) => Caixinha.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Resposta inesperada ao listar caixinhas.');
    }
  }

  Future<void> finalizarPlanning() async {
  final resp = await _client.post('planejamento/finalizar/');
  if (resp.statusCode != 200) {
    // Tenta ler mensagem de erro amigável do backend
    String errorMsg;
    try {
      final body = jsonDecode(resp.body);
      errorMsg = body['error'] ?? 'Erro ao finalizar planejamento.';
    } catch (_) {
      errorMsg = 'Erro ao finalizar planejamento.';
    }
    // Agora lança só o texto puro
    throw errorMsg;
  }
  // Se quiser, pode retornar algo aqui para mostrar a mensagem de sucesso do backend
}
}
