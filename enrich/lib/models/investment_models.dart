// lib/models/investment_models.dart
class InvestmentPercentual {
  final String tipo;
  final double percentual;
  InvestmentPercentual({required this.tipo, required this.percentual});
  factory InvestmentPercentual.fromJson(Map<String, dynamic> json) =>
      InvestmentPercentual(
        tipo: json['tipo'],
        percentual: (json['percentual'] as num).toDouble(),
      );
}

class InvestmentLancamento {
  final String tipo;
  final String codigo;
  final double valor_investido;

  InvestmentLancamento({
    required this.tipo,
    required this.codigo,
    required this.valor_investido,
  });

  factory InvestmentLancamento.fromJson(Map<String, dynamic> json) {
    // null → 0.0
    double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
    return InvestmentLancamento(
      tipo: json['tipo'],
      codigo: json['codigo'],
      valor_investido: _toDouble(json['valor_investido']),
    );
  }
}

/// (já existente) posição consolidada
class InvestmentPosicao {
  final String tipo;
  final String codigo;
  final double valor_investido;

  InvestmentPosicao({
    required this.tipo,
    required this.codigo,
    required this.valor_investido,
  });

  factory InvestmentPosicao.fromJson(Map<String, dynamic> json) =>
      InvestmentPosicao(
        tipo: json['tipo'],
        codigo: json['codigo'],
        valor_investido: (json['valor_investido'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'codigo': codigo,
        'total_investido': valor_investido,
      };
}
