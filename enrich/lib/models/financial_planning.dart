import 'caixinha.dart';

class FinancialPlanning {
  final int id;
  final String nome;
  final String descricao;
  final DateTime mes;
  final double totalPlanejado;
  final double totalNaoPlanejado;
  final List<Caixinha> caixinhas;
  final bool podeFinalizar;

  FinancialPlanning({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.mes,
    required this.totalPlanejado,
    required this.totalNaoPlanejado,
    required this.caixinhas,
    required this.podeFinalizar,
  });

  factory FinancialPlanning.fromJson(
    Map<String, dynamic> json,
    List<Caixinha> caixinhas,
    {bool podeFinalizar = false}
  ) {
    return FinancialPlanning(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      mes: DateTime.parse(json['mes']),
      totalPlanejado: (json['total_planejado'] as num).toDouble(),
      totalNaoPlanejado: (json['total_nao_planejado'] as num).toDouble(),
      caixinhas: caixinhas,
      podeFinalizar: podeFinalizar,
    );
  }
}

class Gasto {
  final int id;
  final String nome;
  final double quantia;
  final int caixinhaId;

  Gasto({
    required this.id,
    required this.nome,
    required this.quantia,
    required this.caixinhaId,
  });

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'],
      nome: json['nome'],
      quantia: (json['quantia'] as num).toDouble(),
      caixinhaId: json['caixinha'],
    );
  }
}

class Ganho {
  final int id;
  final String nome;
  final double quantia;

  Ganho({
    required this.id,
    required this.nome,
    required this.quantia,
  });

  factory Ganho.fromJson(Map<String, dynamic> json) {
    return Ganho(
      id: json['id'],
      nome: json['nome'],
      quantia: (json['quantia'] as num).toDouble(),
    );
  }
}

class HistoricoPlanejamento {
  final int id;
  final int userId;
  final DateTime mes;
  final String nome;
  final String descricao;
  final List<dynamic> dadosCaixinhas; // pode ser List<Caixinha> se for estruturado

  HistoricoPlanejamento({
    required this.id,
    required this.userId,
    required this.mes,
    required this.nome,
    required this.descricao,
    required this.dadosCaixinhas,
  });

  factory HistoricoPlanejamento.fromJson(Map<String, dynamic> json) {
    return HistoricoPlanejamento(
      id: json['id'],
      userId: json['user'],
      mes: DateTime.parse(json['mes']),
      nome: json['nome'],
      descricao: json['descricao'],
      dadosCaixinhas: json['dados_caixinhas'],
    );
  }
}
