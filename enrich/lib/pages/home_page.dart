import 'package:enrich/pages/credit_cards_invoice_page.dart';
import 'package:enrich/pages/debts_page.dart';
import 'package:enrich/pages/emergence_reserve_page.dart';
import 'package:enrich/pages/choose_financial_planning_page.dart';
import 'package:enrich/pages/goals_page.dart';
import 'package:enrich/pages/investments_page.dart';
import 'package:enrich/pages/reports_page.dart';
import 'package:enrich/widgets/home_page_divida_widget.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/home_page_widget.dart';
import '../widgets/little_list_tile.dart';
import '../widgets/texts/title_text.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nomeUsuario;
  final ApiBaseClient apiClient = ApiBaseClient();

  @override
  void initState() {
    super.initState();
    _buscarNomeUsuario();
  }

  Future<void> _buscarNomeUsuario() async {
    final response = await apiClient.get(
      'profile/primeiro_nome/',
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        nomeUsuario = responseData['primeiro_nome'];
      });
    } else {
      throw Exception('Erro ao buscar o nome do usuário.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

    final double valorAtualReservaEmergencia = 1500.00;
    final double valorMetaReservaEmergencia = 20000.00;
    final double progressoReservaEmergencia =
        valorAtualReservaEmergencia / valorMetaReservaEmergencia;

    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: ListView(padding: EdgeInsets.zero, children: [
        Container(
          color: Theme.of(context).colorScheme.onSurface,
          child: Column(
            children: [
              Container(
                height: 330,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      TitleText(
                        text: 'Olá, ${nomeUsuario ?? 'Usuário'}!',
                        fontSize: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SubtitleText(
                            text: 'Setembro de 2024 - ',
                            fontSize: 13,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ReportsPage()),
                              );
                            },
                            child: TitleText(
                                color: Theme.of(context).colorScheme.primary,
                                text: 'Exibir relatórios',
                                fontSize: 13,
                                sublined: true),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.north,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 30),
                        title: Row(
                          children: [
                            LittleText(text: 'Ganhos:  '),
                            TitleText(
                              color: Theme.of(context).colorScheme.primary,
                              text: 'R\$1500.00',
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.south,
                            color: Theme.of(context).colorScheme.surface,
                            size: 30),
                        title: Row(
                          children: [
                            LittleText(text: 'Gastos:  '),
                            TitleText(
                              color: Theme.of(context).colorScheme.surface,
                              text: 'R\$700.00',
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.wallet_sharp,
                          color: Colors.black,
                          size: 30,
                        ),
                        title: Row(
                          children: [
                            LittleText(text: 'Total:  '),
                            TitleText(
                              text: 'R\$800.00',
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 30),
              HomePageWidget(
                titleText: "Planejamento Financeiro",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const ChooseFinancialPlanningPage()),
                  );
                },
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110,
                      width: 100,
                      child: SfCircularChart(series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                            dataSource: chartData,
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y)
                      ]),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LittleListTile(
                          circleColor: Color(0xFFF82E52),
                          category: "Essenciais",
                          percentage: "55%",
                        ),
                        LittleListTile(
                          circleColor: Color(0xFFFFCE06),
                          category: "Lazer",
                          percentage: "10%",
                        ),
                        LittleListTile(
                          circleColor: Color(0xFF2D8BBA),
                          category: "Investimentos",
                          percentage: "20%",
                        ),
                        LittleListTile(
                          circleColor: Color(0xFF5FAF46),
                          category: "Educação",
                          percentage: "5%",
                        ),
                        LittleListTile(
                          circleColor: Color(0xFFCB6CE6),
                          category: "Dívidas",
                          percentage: "10%",
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              HomePageWidget(
                  titleText: "Metas",
                  content: Row(
                    children: [
                      SizedBox(
                        width: 17,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LittleText(
                            text: "- Comprar carro: 55%",
                            fontSize: 12,
                          ),
                          LittleText(text: "- Viajar para Gramado: 20%")
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GoalsPage()),
                              );
                  }),
              SizedBox(height: 20),
              HomePageWidget(
                  titleText: "Dívidas",
                  content: const Row(
                    children: [
                      SizedBox(
                        width: 17,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          HomePageDividaWidget(
                            category: "Em atraso",
                            debtName: "- Desenvolvedor.IO: 29/09/2024",
                          ),
                          SizedBox(height: 7),
                          HomePageDividaWidget(
                            category: "Data próxima",
                            debtName: "- Curso de Marketing: 05/10/2024",
                          ),
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DebtsPage()),
                              );
                  }),
              SizedBox(
                height: 20,
              ),
              HomePageWidget(
                  titleText: "Faturas de Cartão",
                  content: const Row(
                    children: [
                      SizedBox(
                        width: 17,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          HomePageDividaWidget(
                            category: "Em atraso",
                            debtName: "- Cartão de Crédito Nubank: 29/09/2024",
                          ),
                          SizedBox(height: 7),
                          HomePageDividaWidget(
                            category: "Data próxima",
                            debtName: "- Cartão de Crédito PicPay: 05/10/2024",
                          ),
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CreditCardsInvoicePage()),
                              );
                  }),
              SizedBox(
                height: 20,
              ),
              HomePageWidget(
                  titleText: "Reserva de Emergência",
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AmountText(
                                amount: '${valorAtualReservaEmergencia}'),
                            Row(
                              children: [
                                const LittleText(
                                  text: "de ",
                                  fontSize: 8,
                                  textAlign: TextAlign.start,
                                ),
                                AmountText(
                                  amount: '${valorMetaReservaEmergencia}',
                                  fontSize: 8,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progressoReservaEmergencia,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EmergenceReservePage()),
                              );
                  }),
              SizedBox(
                height: 20,
              ),
              HomePageWidget(
                  titleText: "Investimentos",
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AmountText(
                                  amount: '29.657,92',
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                LittleText(
                                  fontSize: 8,
                                  text: '  investidos',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(
                                  text: 'Próximo investimento programado:',
                                  fontSize: 13,
                                ),
                                LittleText(
                                  text: '05/10/2024',
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InvestmentsPage()),
                              );
                  }),
              SizedBox(height: 90),
            ],
          ),
        ),
      ]),
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
