class Cartao {
  final int id;
  final String nome;
  final double valor;
  final DateTime dataFinal;
  final bool isPago;
  final String status;   // “Pago”, “Em atraso”, etc. – vem do backend

  Cartao({
    required this.id,
    required this.nome,
    required this.valor,
    required this.dataFinal,
    required this.isPago,
    required this.status,
  });

  factory Cartao.fromJson(Map<String, dynamic> json) => Cartao(
        id        : json['id'],
        nome      : json['nome'],
        valor     : (json['valor'] as num).toDouble(),
        dataFinal : DateTime.parse(json['data_final']),
        isPago    : json['is_pago'],
        status    : json['status'],
      );

  Map<String, dynamic> toJson() => {
        'nome'      : nome,
        'valor'     : valor,
        'data_final': dataFinal.toIso8601String(),
        'is_pago'   : isPago,
      };

  /// cópia imutável para facilitar updates
  Cartao copyWith({bool? isPago}) => Cartao(
        id        : id,
        nome      : nome,
        valor     : valor,
        dataFinal : dataFinal,
        isPago    : isPago ?? this.isPago,
        status    : status,
      );
}
