// Carteira de investimentos detalhada.
// Exibe cada posição (tipo + código) com entradas, vendas e saldo.
// Depende de:
//   • InvestmentService  (services/investment_service.dart)
//   • InvestmentPosicao  (models/investment_models.dart)
//   • TitleText / LittleText
//

import 'package:flutter/material.dart';
import '../models/investment_models.dart';
import '../services/investment_service.dart';
import '../widgets/texts/title_text.dart';
import '../widgets/texts/little_text.dart';

class InvestmentWalletPage extends StatefulWidget {
  const InvestmentWalletPage({super.key});

  @override
  State<InvestmentWalletPage> createState() => _InvestmentWalletPage();
}

class _InvestmentWalletPage extends State<InvestmentWalletPage> {
  final _svc = InvestmentService();
  late Future<List<InvestmentPosicao>> _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.fetchPosicoes();
  }

  Future<void> _recarregar() async {
    setState(() => _future = _svc.fetchPosicoes());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onSurface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        title: const TitleText(text: 'Minha Carteira', fontSize: 18),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: FutureBuilder<List<InvestmentPosicao>>(
          future: _future,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(backgroundColor: Colors.green, color: Colors.white,));
            }
            if (snap.hasError) {
              return Center(child: Text('Erro: ${snap.error}'));
            }
            final data = snap.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text('Nenhum investimento ainda.'));
            }

            // Ordena por tipo e código para uma leitura mais fácil
            data.sort((a, b) {
              final byTipo = a.tipo.compareTo(b.tipo);
              return byTipo != 0 ? byTipo : a.codigo.compareTo(b.codigo);
            });

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: data.length,
              separatorBuilder: (_, __) => Divider(
                color: const Color.fromARGB(255, 148, 174, 187),
              ),
              itemBuilder: (_, i) {
                final p = data[i];
                final saldoPositivo = p.saldo >= 0;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: saldoPositivo
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    child: Icon(
                      saldoPositivo ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${p.codigo} – ${p.tipo}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    'Entradas: R\$${p.totalEntrada.toStringAsFixed(2)}   '
                    'Vendas: R\$${p.totalVenda.toStringAsFixed(2)}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Saldo',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        'R\$${p.saldo.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: saldoPositivo
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
