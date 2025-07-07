import 'package:enrich/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/financial_planning.dart';
import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';
import '../services/financial_planning_service.dart';
import '../utils/api_base_client.dart';

class FinancialPlanningPage extends StatefulWidget {
  const FinancialPlanningPage({super.key});

  @override
  State<FinancialPlanningPage> createState() => _FinancialPlanningPageState();
}

class _FinancialPlanningPageState extends State<FinancialPlanningPage> {
  FinancialPlanning? planning;
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _carregarPlanejamento();
  }

  Future<void> _carregarPlanejamento() async {
    try {
      // Busque o planejamento (ajuste para seu service/model)
      final p =
          await FinancialPlanningService(ApiBaseClient()).getExistingPlanning();
      setState(() {
        planning = p;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = 'Erro ao buscar planejamento financeiro';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      );
    }

    if (errorMsg != null || planning == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Planejamento Financeiro"),
          leading: BackButton(),
        ),
        body: Center(child: Text(errorMsg ?? 'Erro')),
      );
    }

    const double horizontalPadding = 30.0;
    final colors = [Colors.purple, Colors.blue, Colors.grey];

    final List<ChartData> chartData = planning!.caixinhas.map((c) {
      final idx = planning!.caixinhas.indexOf(c);
      final color = colors[idx < colors.length ? idx : 0];
      return ChartData(c.nome, c.porcentagem, color);
    }).toList();

    final double totalPlanejado = planning!.totalPlanejado;
    final double totalNaoPlanejado = planning!.totalNaoPlanejado;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          children: [
            const SizedBox(height: 20),
            const TitleText(text: 'Planejamento Financeiro', fontSize: 20),
            const SizedBox(height: 20),

            // Gráfico de pizza
            SizedBox(
              height: 170,
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const TitleText(text: 'Total planejado', fontSize: 13),
            TitleText(
              text: 'R\$ ${totalPlanejado.toStringAsFixed(2)}',
              color: Theme.of(context).colorScheme.secondary,
            ),
            LittleText(
              text:
                  'R\$ ${totalNaoPlanejado.toStringAsFixed(2)} não planejados',
              fontSize: 13,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 20),
            const TitleText(text: 'Caixinhas', fontSize: 17),
            const SizedBox(height: 10),

            // Lista de caixinhas com cores originais
            ...planning!.caixinhas.map((c) {
              final idx = planning!.caixinhas.indexOf(c);
              final color = colors[idx < colors.length ? idx : 0];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Primeira linha: Ícone, nome e porcentagem
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                color: color,
                                width: 25,
                                height: 25,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/planning_page_jar.png',
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TitleText(
                                text: c.nome,
                                fontSize: 13,
                              ),
                            ),
                            TitleText(
                              text: '${c.porcentagem.toStringAsFixed(0)}%',
                              fontSize: 14,
                              color: color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Segunda linha: Planejado e Realizado
                        Row(
                          children: [
                            LittleText(
                              text:
                                  'Planejado: R\$ ${c.valorMeta.toStringAsFixed(2)}',
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 10),
                            LittleText(
                              text:
                                  'Realizado: R\$ ${c.valorTotal.toStringAsFixed(2)}',
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            // ... depois do .map das caixinhas
            const SizedBox(height: 30),


            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      "Finalizar Planejamento",
                      style: TextStyle(color: Colors.black),
                    ),
                    content: const Text(
                      "Tem certeza que deseja finalizar este planejamento? Essa ação não pode ser desfeita.",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Finalizar"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await FinancialPlanningService(ApiBaseClient())
                        .finalizarPlanning();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                            'Planejamento finalizado e arquivado com sucesso!'),
                      ),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text("Finalizar Planejamento"),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
