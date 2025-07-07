import 'package:enrich/pages/home_page.dart';
import 'package:enrich/widgets/create_object_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/financial_planning.dart';
import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';
import '../services/financial_planning_service.dart';
import '../utils/api_base_client.dart';
import '../widgets/form_widget.dart';

class CustomFinancialPlanningPage extends StatefulWidget {
  const CustomFinancialPlanningPage({super.key});

  @override
  State<CustomFinancialPlanningPage> createState() =>
      _CustomFinancialPlanningPageState();
}

class _CustomFinancialPlanningPageState
    extends State<CustomFinancialPlanningPage> {
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

  void _abrirModalCriarCaixinha() {
    final nomeController = TextEditingController();
    final porcController = TextEditingController();

    showCreateObjectModal(
      context: context,
      title: 'Nova Caixinha',
      fields: [
        FormWidget(
          hintText: 'Nome da caixinha',
          controller: nomeController,
          onChanged: (_) {},
        ),
        FormWidget(
          hintText: 'Porcentagem (%)',
          controller: porcController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) {},
        ),
      ],
      onSave: () async {
        final nome = nomeController.text.trim();
        final porcentagem = double.tryParse(porcController.text.trim()) ?? 0.0;

        if (nome.isEmpty || porcentagem <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preencha os campos corretamente')),
          );
          return;
        }
        try {
          await FinancialPlanningService(ApiBaseClient())
              .criarCaixinha(nome: nome, porcentagem: porcentagem);
          await _carregarPlanejamento();
          Navigator.of(context).pop(); // fecha o modal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Caixinha criada!')),
          );
        } catch (e) {
          print('Erro ao criar caixinha: $e');
        }
      },
    );
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
          title: const Text("Planejamento Personalizado"),
          leading: BackButton(),
        ),
        body: Center(child: Text(errorMsg ?? 'Erro')),
      );
    }

    const double horizontalPadding = 30.0;
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.grey,
      Colors.orange,
      Colors.green,
      Colors.red
    ];

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
            const TitleText(text: 'Planejamento Personalizado', fontSize: 20),
            const SizedBox(height: 10),

            // Botão para criar caixinha
            ElevatedButton.icon(
              onPressed: _abrirModalCriarCaixinha,
              icon: const Icon(Icons.add_box_outlined),
              label: const Text('Criar caixinha'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
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

            // Lista de caixinhas
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
            
            // Removido do escopo
            // OutlinedButton.icon(
            //   onPressed: () async {
            //     setState(() {
            //       loading = true;
            //       errorMsg = null;
            //     });
            //     try {
            //       await FinancialPlanningService(ApiBaseClient())
            //           .importarDividasParaGastos();
            //       await _carregarPlanejamento();
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //           backgroundColor: Colors.green,
            //           content:
            //               Text('Gastos em dívidas importados com sucesso!'),
            //         ),
            //       );
            //     } catch (e) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           backgroundColor: Colors.red,
            //           content: Text(e.toString()),
            //         ),
            //       );
            //     } finally {
            //       setState(() {
            //         loading = false;
            //       });
            //     }
            //   },
            //   style: OutlinedButton.styleFrom(
            //     side:
            //         BorderSide(color: Theme.of(context).colorScheme.secondary),
            //     foregroundColor: Theme.of(context).colorScheme.secondary,
            //     minimumSize: const Size(double.infinity, 48),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(14)),
            //     textStyle:
            //         const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //   ),
            //   icon: const Icon(Icons.import_export),
            //   label: const Text('Importar gastos em dívidas'),
            // ),

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
