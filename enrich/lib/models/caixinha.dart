class Caixinha {
  final int id;
  final String nome;
  final double porcentagem;
  final double valorMeta;
  final double valorTotal;

  Caixinha({
    required this.id,
    required this.nome,
    required this.porcentagem,
    required this.valorMeta,
    required this.valorTotal,
  });

  factory Caixinha.fromJson(Map<String, dynamic> json) {
    return Caixinha(
      id: json['id'],
      nome: json['nome'],
      porcentagem: (json['porcentagem'] as num).toDouble(),
      valorMeta: (json['valor_meta'] as num).toDouble(),
      valorTotal: (json['valor_total'] as num).toDouble(),
    );
  }
}
