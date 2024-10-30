import 'package:enrich/pages/investment_quiz_page.dart';
import 'package:enrich/pages/reports_page.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/little_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/little_text_tile.dart';
import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';

class InvestmentsPage extends StatelessWidget {
  const InvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        appBar: AppBar(
          leadingWidth: 100,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 14,
                ),
                SizedBox(
                  width: 2,
                ),
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
        body: Container(
          color: Theme.of(context).colorScheme.onSurface,
          child: ListView(padding: EdgeInsets.zero, children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: 'Investimentos',
                    fontSize: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InvestmentQuizPage()),
                      );
                    },
                    child: Text(
                      'Ver sugestões personalizadas de investimentos.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.tertiary,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: HomePageWidget(
                  height: 100,
                  titleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitleText(
                          text: 'R\$29.657,92',
                          color: Theme.of(context).colorScheme.tertiary),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: LittleText(text: 'investidos.'),
                      )
                    ],
                  ),
                  titleText: '',
                  menuIcon: GestureDetector(
                      onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                  content: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          LittleTextTile(
                            iconColor: Colors.green,
                            text: "Adicionar investimento",
                            icon: Icon(Icons.add_circle_sharp),
                            iconSize: 24,
                            fontSize: 9,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          LittleTextTile(
                            iconColor: Colors.red,
                            text: "Adicionar venda de ação",
                            icon: Icon(Icons.remove_circle_sharp),
                            iconSize: 24,
                            fontSize: 9,
                          ),
                        ],
                      ),
                    ],
                  ),
                  showSeeMoreText: false,
                  onPressed: () {}),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: HomePageWidget(
                  height: 105,
                  showSeeMoreText: false,
                  titleText: 'Notificar para investir',
                  content: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: SizedBox(
                              width: 190,
                              child: LittleText(
                                text:
                                    'Escolha o valor mensal a investir eo dia a ser notificado.',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(width: 70,),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 30
                          )
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {}),
            ),
            SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: HomePageWidget(
                          seeMoreTextString: 'Ver carteira',
                          seeMoreTextColor: Theme.of(context).colorScheme.tertiary,
                          titleText: "Planejamento Financeiro",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => const ReportsPage()),
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
                      ),
                      SizedBox(height: 20),
                      Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: HomePageWidget(
                  height: 110,
                  showSeeMoreText: false,
                  titleText: 'Simulações de Resultados',
                  content: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: SizedBox(
                              width: 190,
                              child: LittleText(
                                text:
                                    'Simule os resultados que você terá com seus investimentos ao longo do tempo.',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(width: 70,),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 30
                          )
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {}),
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