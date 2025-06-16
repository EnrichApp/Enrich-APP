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
  final double entrada;
  final double venda;

  InvestmentLancamento({
    required this.tipo,
    required this.codigo,
    required this.entrada,
    required this.venda,
  });

  factory InvestmentLancamento.fromJson(Map<String, dynamic> json) {
    // null → 0.0
    double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
    return InvestmentLancamento(
      tipo:   json['tipo'],
      codigo: json['codigo'],
      entrada: _toDouble(json['entrada']),
      venda:   _toDouble(json['venda']),
    );
  }
}

/// (já existente) posição consolidada
class InvestmentPosicao {
  final String tipo;
  final String codigo;
  final double totalEntrada;
  final double totalVenda;
  final double saldo;

  InvestmentPosicao({
    required this.tipo,
    required this.codigo,
    required this.totalEntrada,
    required this.totalVenda,
    required this.saldo,
  });

  factory InvestmentPosicao.fromJson(Map<String, dynamic> json) =>
      InvestmentPosicao(
        tipo: json['tipo'],
        codigo: json['codigo'],
        totalEntrada: (json['total_entrada'] as num).toDouble(),
        totalVenda:   (json['total_venda']   as num).toDouble(),
        saldo:        (json['saldo']         as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'codigo': codigo,
        'total_entrada': totalEntrada,
        'total_venda': totalVenda,
        'saldo': saldo,
      };
}
