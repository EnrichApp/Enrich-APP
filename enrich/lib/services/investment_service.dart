// lib/services/investment_service.dart
//
// Serviço único para conversar com o backend de investimentos.
// ­– Usa apenas endpoints já existentes no Django –
//
// Endpoints consumidos
// ─────────────────────────────────────────────────────────
// • GET  investimento/total_investido/   → total investido do usuário
// • GET  investimento/carteira/          → percentuais (pizza)
// • GET  investimento/listar/            → histórico bruto (entradas/vendas)
// • POST investimento/adicionar_investimentos/ ─ cria nova ENTRADA
// • POST investimento/registrar_venda/   ─ cria nova VENDA
// • GET  investimento/listar_fiis/       → lista de FIIs (autocomplete)
// ─────────────────────────────────────────────────────────
//
// Depende de:
//   • ApiBaseClient      (utils/api_base_client.dart)
//   • Investment models  (lib/models/investment_models.dart)
//

import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';
import '../models/investment_models.dart';

class InvestmentService {
  final _client = ApiBaseClient();

  /* ────────── 1. RESUMO (Total investido) ────────── */

  Future<double> fetchTotalInvestido() async {
    final res = await _client.get('investimento/total_investido/');
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['total_investido'] as num).toDouble();
    }
    throw Exception('Erro ao obter total investido');
  }

  /* ────────── 2. PERCENTUAIS DA PIZZA ────────── */

  Future<List<InvestmentPercentual>> fetchPercentuais() async {
    final res = await _client.get('investimento/carteira/');
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body)['percentuais'] as List;
      return list.map((e) => InvestmentPercentual.fromJson(e)).toList();
    }
    throw Exception('Erro ao obter percentuais');
  }

  /* ────────── 3. ADICIONAR NOVO INVESTIMENTO (ENTRADA) ────────── */

  Future<void> adicionarInvestimento({
    required String tipo,
    required String codigo,
    required double valor,
  }) async {
    final res = await _client.post(
      'investimento/adicionar_investimentos/',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tipo': tipo,
        'codigo': codigo,
        'entrada': valor,
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Falha ao adicionar investimento');
    }
  }

  /* ────────── 4. REGISTRAR VENDA ────────── */

  Future<void> registrarVenda({
    required String tipo,
    required String codigo,
    required double valor,
  }) async {
    final res = await _client.post(
      'investimento/registrar_venda/',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tipo': tipo,
        'codigo': codigo,
        'venda': valor,
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Falha ao registrar venda');
    }
  }

  /* ────────── 5. POSIÇÕES CONSOLIDADAS (usa investimento/listar/) ────────── */

  Future<List<InvestmentPosicao>> fetchPosicoes() async {
    final res = await _client.get('investimento/listar/');
    if (res.statusCode != 200) {
      throw Exception('Erro ao obter histórico (status ${res.statusCode})');
    }

    final List histRaw = jsonDecode(res.body);
    final historico =
        histRaw.map((e) => InvestmentLancamento.fromJson(e)).toList();

    // agrupa por tipo+codigo
    final Map<String, InvestmentPosicao> mapa = {};

    for (var l in historico) {
      final key = '${l.tipo}|${l.codigo}';
      final existente = mapa[key];

      if (existente == null) {
        mapa[key] = InvestmentPosicao(
          tipo: l.tipo,
          codigo: l.codigo,
          totalEntrada: l.entrada,
          totalVenda: l.venda,
          saldo: l.entrada - l.venda,
        );
      } else {
        mapa[key] = InvestmentPosicao(
          tipo: existente.tipo,
          codigo: existente.codigo,
          totalEntrada: existente.totalEntrada + l.entrada,
          totalVenda: existente.totalVenda + l.venda,
          saldo: (existente.totalEntrada + l.entrada) -
              (existente.totalVenda + l.venda),
        );
      }
    }

    return mapa.values.toList();
  }

  /* ────────── 6. LISTA DE FIIs PARA AUTOCOMPLETE ────────── */

  Future<List<String>> fetchFiis() async {
    final res = await _client.get('investimento/listar_fiis/');
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body)['lista_de_fiis'];
      return list.cast<String>();
    }
    throw Exception('Erro ao obter lista de FIIs');
  }
}
