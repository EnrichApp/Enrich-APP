// Carteira de investimentos detalhada.
// Exibe cada posição (tipo + código) com entradas, vendas e saldo.
// Depende de:
//   • InvestmentService  (services/investment_service.dart)
//   • InvestmentPosicao  (models/investment_models.dart)
//   • TitleText / LittleText
//

import 'dart:convert';

import 'package:enrich/utils/api_base_client.dart';
import 'package:flutter/material.dart';
import '../models/investment_models.dart';
import '../services/investment_service.dart';
import '../widgets/texts/title_text.dart';
import '../widgets/texts/little_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    final novaFuture = _svc.fetchPosicoes();
    setState(() {
      _future = novaFuture;
    });
  }
  
  final ApiBaseClient apiClient = ApiBaseClient();

  Future<void> _onExcluirInvestimento(
      InvestmentPosicao posicao, BuildContext context) async {
    try {
      final response = await apiClient.post(
        'investimento/excluir/',
        body: jsonEncode({'tipo': posicao.tipo, 'codigo': posicao.codigo}),
      );

      if (response.statusCode == 200) {
        await _recarregar();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ativo excluído da sua carteira com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      final msg =
          'Ocorreu um erro ao excluir o ativo da sua carteira. Tente novamente mais tarde.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                color: Colors.white,
              ));
            }
            if (snap.hasError) {
              return Center(child: Text('Erro: ${snap.error}'));
            }
            final data = snap.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text('Nenhum investimento ainda.'));
            }

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
                final saldoPositivo = p.valor_investido >= 0;
                return Slidable(
                  key: ValueKey('${p.tipo}-${p.codigo}'),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text(
                                'Confirmar exclusão',
                                style: TextStyle(color: Colors.black),
                              ),
                              content: Text(
                                'Deseja realmente excluir ${p.codigo} da sua carteira?',
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Excluir',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirmar == true) {
                            _onExcluirInvestimento(p, context);
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Excluir',
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 0, right: 20),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Saldo',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          'R\$${p.valor_investido.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: saldoPositivo
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
