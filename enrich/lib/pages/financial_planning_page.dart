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
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  color: Colors.white,
                  height: 70,
                  child: ListTile(
                    leading: ClipOval(
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            color: color,
                            width: 45,
                            height: 45,
                          ),
                          Image.asset(
                            'assets/images/planning_page_jar.png',
                            height: 23,
                            width: 23,
                          ),
                        ],
                      ),
                    ),
                    title: TitleText(text: c.nome, fontSize: 13),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TitleText(
                          text: '${c.porcentagem.toStringAsFixed(0)}%',
                          fontSize: 17,
                          color: color,
                        ),
                        TitleText(
                          text: 'R\$ ${c.valorMeta.toStringAsFixed(2)}',
                          fontSize: 15,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              );
            }).toList(),
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
