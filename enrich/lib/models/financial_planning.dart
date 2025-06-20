import 'caixinha.dart';

class FinancialPlanning {
  final int id;
  final String nome;
  final String descricao;
  final DateTime mes;
  final double totalPlanejado;
  final double totalNaoPlanejado;
  final List<Caixinha> caixinhas;

  FinancialPlanning({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.mes,
    required this.totalPlanejado,
    required this.totalNaoPlanejado,
    required this.caixinhas,
  });

  factory FinancialPlanning.fromJson(
    Map<String, dynamic> json,
    List<Caixinha> caixinhas,
  ) {
    return FinancialPlanning(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      mes: DateTime.parse(json['mes']),
      totalPlanejado: (json['total_planejado'] as num).toDouble(),
      totalNaoPlanejado: (json['total_nao_planejado'] as num).toDouble(),
      caixinhas: caixinhas,
    );
  }
}
