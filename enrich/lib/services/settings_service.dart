import 'dart:convert';
import 'package:enrich/models/settings.dart';
import 'package:enrich/utils/api_base_client.dart';

class ChangePasswordService {
  final _client = ApiBaseClient();

  Future<String?> changePassword(ChangePasswordModel model) async {
    final response = await _client.patch(
      'alterar_senha/',
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      try {
        final decoded = jsonDecode(response.body);
        return decoded['detail'] ?? 'Erro ao alterar senha.';
      } catch (_) {
        return 'Erro inesperado ao tentar alterar a senha.';
      }
    }
  }
}

class ExcluirContaService {
  final _client = ApiBaseClient();

  Future<String?> deleteAccount() async {
    final response = await _client.delete(
      'deletar_conta/',
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      try {
        final decoded = jsonDecode(response.body);
        return decoded['detail'] ?? 'Erro ao deletar conta.';
      } catch (_) {
        return 'Erro inesperado ao tentar deletar conta.';
      }
    }
  }
}

class AtualizarRendaService {
  final _client = ApiBaseClient();

  Future<String?> updateIncome(UpdateIncomeModel model) async {
    final response = await _client.patch(
      'profile/me/',
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      try {
        final decoded = jsonDecode(response.body);
        return decoded['detail'] ?? 'Erro ao atualizar renda.';
      } catch (_) {
        return 'Erro inesperado ao tentar atualizar renda.';
      }
    }
  }
}
