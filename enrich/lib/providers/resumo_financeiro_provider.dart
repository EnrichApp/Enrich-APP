import 'dart:convert';

import 'package:enrich/utils/api_base_client.dart';
import 'package:flutter/material.dart';

class ResumoFinanceiroProvider with ChangeNotifier {
  double ganhos = 0.0;
  double gastos = 0.0;
  double total = 0.0;

  Future<void> buscarResumo(ApiBaseClient apiClient) async {
    final response = await apiClient.get('profile/resumo-financeiro/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ganhos = (responseData['total_ganhos'] ?? 0).toDouble();
      gastos = (responseData['total_gastos'] ?? 0).toDouble();
      total = (responseData['lucro'] ?? 0).toDouble();
      notifyListeners();
    }
  }
}