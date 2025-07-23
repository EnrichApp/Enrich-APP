import 'dart:async';
import 'dart:convert';
import 'package:enrich/pages/investment_quiz_result_page.dart';
import 'package:enrich/pages/investment_wallet.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/container_widget.dart';
import 'package:enrich/widgets/searchable_dropdown_widget.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/investment_models.dart';
import '../pages/investment_quiz_page.dart';
import '../pages/investment_simulation_page.dart';
import '../services/investment_service.dart';
import '../widgets/circular_icon.dart';
import '../widgets/home_page_widget.dart';
import '../widgets/little_list_tile.dart';
import '../widgets/little_text_tile.dart';
import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';
import '../widgets/create_object_widget.dart';

class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({super.key});

  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  final InvestmentService _svc = InvestmentService();

  double? _totalInvestido;
  List<ChartData> _chartData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  final ApiBaseClient apiClient = ApiBaseClient();

  Future<void> _consultarPerfilInvestidorEDirecionarParaPagina(
      BuildContext context) async {
    try {
      final response = await apiClient.get(
        'investimento/perfil_investidor/',
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final perfil = body['perfil_investidor'];
        final sugestoes = List<String>.from(body['sugestoes']);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => InvestmentQuizResultPage(
                    perfil: perfil,
                    sugestoes: sugestoes,
                    jaSalvo: true
                  )),
        );
      } else if (response.statusCode == 404) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => InvestmentQuizPage()),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erro ao consultar o seu perfil de investidor. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _carregarDados() async {
    try {
      final total = await _svc.fetchTotalInvestido();
      final percentuais = await _svc.fetchPercentuais();
      setState(() {
        _totalInvestido = total;
        _chartData = _mapPercentuaisToChart(percentuais);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados: $e')),
      );
    }
  }

  List<ChartData> _mapPercentuaisToChart(List<InvestmentPercentual> list) {
    const colorMap = {
      'FIIs': Color(0xFF2D8BBA),
      'Ações Exterior': Color(0xFFF82E52),
      'Renda Fixa': Color(0xFFFFCE06),
      'Commodities': Color(0xFF5FAF46),
      'Fundos Multimercado': Color(0xFFCB6CE6),
    };

    return list
        .where((e) => e.percentual > 0)
        .map((e) => ChartData(
              e.tipo,
              e.percentual,
              colorMap[e.tipo] ?? Colors.grey,
            ))
        .toList();
  }

  Future<void> _abrirModalAdicionarInvestimento() async {
    final codigoCtrl = TextEditingController();
    final valorCtrl = TextEditingController();

    // Controladores de estado do modal
    String? tipoSelecionado;
    List<String> listaFiis = [];
    bool carregandoFiis = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        // permite setState interno ao modal
        return StatefulBuilder(
          builder: (ctx, setStateModal) => CreateObjectWidget(
            title: 'Registrar investimento',
            fields: [
              // ---------- COMBO BOX DE TIPOS ----------
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration: const InputDecoration(labelText: 'Tipo'),
                dropdownColor: Colors.white,
                focusColor: Theme.of(context).colorScheme.tertiary,
                
                items: const [
                  DropdownMenuItem(
                      value: 'FIIs',
                      child: Text(
                        'FIIs',
                        style: TextStyle(color: Colors.black),
                      )),
                  DropdownMenuItem(
                      value: 'Ações Exterior',
                      child: Text(
                        'Ações Exterior',
                        style: TextStyle(color: Colors.black),
                      )),
                  DropdownMenuItem(
                      value: 'Renda Fixa',
                      child: Text(
                        'Renda Fixa',
                        style: TextStyle(color: Colors.black),
                      )),
                  DropdownMenuItem(
                      value: 'Commodities',
                      child: Text(
                        'Commodities',
                        style: TextStyle(color: Colors.black),
                      )),
                  DropdownMenuItem(
                      value: 'Fundos Multimercado',
                      child: Text(
                        'Fundos Multimercado',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
                onChanged: (val) async {
                  setStateModal(() {
                    tipoSelecionado = val;
                    codigoCtrl.text = ''; // limpa código
                  });
                  // se selecionou FIIs, busca lista no backend
                  if (val == 'FIIs' && listaFiis.isEmpty) {
                    setStateModal(() => carregandoFiis = true);
                    try {
                      listaFiis = await _svc.fetchFiis();
                    } catch (_) {
                      listaFiis = [];
                    }
                    setStateModal(() => carregandoFiis = false);
                  }
                },
              ),

              // ---------- CAMPO DE CÓDIGO ----------
              if (tipoSelecionado == 'FIIs')
                carregandoFiis
                    ? const Center(child: LinearProgressIndicator())
                    : SearchableDropdown(
                        label: 'Código do FII',
                        items: listaFiis,
                        selected:
                            codigoCtrl.text.isNotEmpty ? codigoCtrl.text : null,
                        onChanged: (val) => codigoCtrl.text = val,
                      )
              else
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: codigoCtrl,
                  decoration: const InputDecoration(labelText: 'Código'),
                ),

              // ---------- VALOR ----------
              TextField(
                style: const TextStyle(color: Colors.black),
                controller: valorCtrl,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
            onSave: () async {
              final tipo = tipoSelecionado;
              final codigo = codigoCtrl.text.trim();
              final valor =
                  double.tryParse(valorCtrl.text.replaceAll(',', '.'));

              if (tipo == null || codigo.isEmpty || valor == null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Preencha todos os campos.')),
                );
                return;
              }

              try {
                await _svc.adicionarInvestimento(
                  tipo: tipo,
                  codigo: codigo,
                  valor: valor,
                );
                if (mounted) Navigator.of(ctx).pop(true); // sucesso
              } catch (e) {
                print('Erro ao registrar investimento: $e');
              }
            },
            onCancel: () => Navigator.of(ctx).pop(false),
          ),
        );
      },
    ).then((salvou) {
      if (salvou == true) _carregarDados();
    });
  }

  Future<void> _abrirModalRegistrarVenda() async {
    final valorCtrl = TextEditingController();
    final List<InvestmentPosicao> posicoes = await _svc.fetchPosicoes();
    final List<InvestmentPosicao> ativos =
        posicoes.where((p) => p.valor_investido > 0).toList();

    InvestmentPosicao? selecionado;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateModal) => CreateObjectWidget(
            title: 'Registrar venda',
            fields: [
              DropdownButtonFormField<InvestmentPosicao>(
                value: selecionado,
                decoration: const InputDecoration(
                  labelText: 'Ativo',
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,
                items: ativos.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text('${p.tipo} - ${p.codigo}',
                        style: const TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) => setStateModal(() => selecionado = val),
              ),
              TextField(
                controller: valorCtrl,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Valor da venda (R\$)',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
            onSave: () async {
              final venda =
                  double.tryParse(valorCtrl.text.replaceAll(',', '.'));
              if (selecionado == null || venda == null) {
                return; // Não faz nada se não estiver completo
              }

              try {
                await _svc.registrarVenda(
                  tipo: selecionado!.tipo,
                  codigo: selecionado!.codigo,
                  valor: venda,
                );

                if (!mounted) return;

                // Mostra snackbar de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Venda registrada com sucesso.'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.of(ctx).pop(true);
              } catch (e) {
                final errorMessage =
                    e.toString().replaceFirst('Exception: ', '');
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            },
            onCancel: () => Navigator.of(ctx).pop(false),
          ),
        );
      },
    ).then((salvou) {
      if (salvou == true) _carregarDados();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
              SizedBox(width: 2),
              LittleText(
                text: 'Voltar',
                fontSize: 12,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(text: 'Investimentos', fontSize: 20),
                        InkWell(
                          onTap: () async {
                          await _consultarPerfilInvestidorEDirecionarParaPagina(context);
                          },
                          child: Text(
                            'Ver sugestões personalizadas de investimentos.',
                            style: TextStyle(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.tertiary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ---- Caixa principal com total investido ----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: HomePageWidget(
                      height: 130,
                      titleWidget: Row(
                        children: [
                          TitleText(
                            text: _totalInvestido != null
                                ? 'R\$${_totalInvestido!.toStringAsFixed(2)}'
                                : 'R\$0,00',
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(width: 5),
                          const Padding(
                            padding: EdgeInsets.only(top: 7.0),
                            child: LittleText(text: 'investidos.'),
                          ),
                        ],
                      ),
                      titleText: '',
                      //menuIcon: const Icon(Icons.more_vert, size: 22),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          children: [
                            LittleTextTile(
                              iconColor: Colors.green,
                              iconSize: 22,
                              text: "Registrar investimento",
                              icon: const CircularIcon(
                                iconData: Icons.add,
                                size: 26,
                                backgroundColor: Colors.green,
                                iconColor: Colors.white,
                              ),
                              onIconTap: _abrirModalAdicionarInvestimento,
                            ),
                            const SizedBox(height: 5),
                            LittleTextTile(
                              iconColor: Colors.red,
                              iconSize: 22,
                              text: "Registrar venda",
                              icon: const CircularIcon(
                                iconData: Icons.remove,
                                size: 26,
                                backgroundColor: Colors.red,
                                iconColor: Colors.white,
                              ),
                              onIconTap: _abrirModalRegistrarVenda,
                            ),
                          ],
                        ),
                      ),
                      showSeeMoreText: false,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ---- Carteira / gráfico ----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: HomePageWidget(
                      height: 200,
                      seeMoreTextString: 'Ver carteira',
                      seeMoreTextColor: theme.colorScheme.tertiary,
                      titleText: 'Carteira',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InvestmentWalletPage()),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 110,
                            width: 100,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                PieSeries<ChartData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  pointColorMapper: (d, _) => d.color,
                                  dataLabelMapper: (d, _) =>
                                      '${d.y.toStringAsFixed(1)}%',
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _chartData
                                  .where((d) => d.y > 0)
                                  .map((d) => LittleListTile(
                                        circleColor: d.color ?? Colors.grey,
                                        category: d.x,
                                        percentage:
                                            '${d.y.toStringAsFixed(1)}%',
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ---- Simulação de resultados ----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => InvestmentSimulationPage()),
                            ),
                      child: HomePageWidget(
                        height: 110,
                        showSeeMoreText: false,
                        titleText: 'Simulações de Resultados',
                        content: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Expanded(
                              child: LittleText(
                                text:
                                    'Simule os resultados que você terá com seus investimentos ao longo do tempo.',
                                textAlign: TextAlign.left,
                              ),
                            ),  
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                              ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}

/// Estrutura de dados utilizada no gráfico.
class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
