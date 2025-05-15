import 'dart:convert';
import 'package:enrich/models/cartao.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/utils/date_format.dart';
import 'package:intl/intl.dart';

class CartaoService {
  final _client = ApiBaseClient();

  Map<String, dynamic> _payload(Cartao c) => {
        'nome'      : c.nome,
        'valor'     : c.valor,
        'data_final': ddMMyyyyToIso(
            DateFormat('dd/MM/yyyy').format(c.dataFinal)),
        'is_pago'   : c.isPago,
      };

  /* CRUD */

  Future<List<Cartao>> listar() async {
    final r = await _client.get('cartoes/');
    if (r.statusCode != 200) {
      throw Exception('Erro ${r.statusCode}: ${r.body}');
    }
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Cartao.fromJson(e)).toList();
  }

  Future<Cartao> criar(Cartao c) async {
    final r = await _client.post('cartoes/', body: jsonEncode(_payload(c)));
    if (r.statusCode != 201) {
      throw Exception('Erro ${r.statusCode}: ${r.body}');
    }
    return Cartao.fromJson(jsonDecode(r.body));
  }

  Future<void> atualizar(int id, Cartao c) async {
    final r =
        await _client.patch('cartoes/$id/', body: jsonEncode(_payload(c)));
    if (r.statusCode != 200) {
      throw Exception('Erro ${r.statusCode}: ${r.body}');
    }
  }

  Future<void> excluir(int id) async {
    final r = await _client.delete('cartoes/$id/');
    if (r.statusCode != 204) {
      throw Exception('Erro ${r.statusCode}: ${r.body}');
    }
  }

  /* helpers extras */

  Future<void> marcarPago(Cartao c) => atualizar(c.id, c.copyWith(isPago: true));
}
