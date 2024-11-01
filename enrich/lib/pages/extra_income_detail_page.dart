import 'package:enrich/widgets/extra_income_widget.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/info_tile.dart';
import 'package:enrich/widgets/little_text_tile.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExtraIncomeDetailPage extends StatelessWidget {
  const ExtraIncomeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Janeiro', 18, Colors.green),
      ChartData('Fevereiro', 26, Colors.green),
      ChartData('Março', 23, Colors.green),
      ChartData('Abril', 30, Colors.green),
      ChartData('Maio', 40, Colors.green),
    ];

    // Definindo o lucro atual e a meta
    final double currentValue = 1900.00;
    final double targetValue = 2000.00;
    final double progress = currentValue / targetValue;

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
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: 'Venda de Brigadeiros',
                    fontSize: 20,
                  ),
                  LittleTextTile(
                      iconColor: Colors.grey,
                      text: "Setembro - 2024",
                      icon: Icon(Icons.keyboard_arrow_down_sharp),
                      inverted: true,
                      iconSize: 30,
                      )
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: Column(
                children: [
                  ExtraIncomeWidget(
                    titleText: "Seu Progresso",
                    littleText:
                        "O gráfico mostra o seu progresso ao longo dos últimos 6 meses referente ao ganho total com as suas fontes de renda extra.",
                    onPressed: () {},
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150, // Altura do gráfico
                          width: 350, // Largura do gráfico
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(),
                            series: <LineSeries<ChartData, String>>[
                              LineSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                color: Colors.green,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  color: Colors.green,
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  HomePageWidget(
                      titleText: "Lucro",
                      menuIcon: GestureDetector(
                          onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AmountText(
                                    amount: '1.900,00', fontSize: 20),
                                Row(
                                  children: const [
                                    LittleText(
                                      text: "de ",
                                      fontSize: 8,
                                      textAlign: TextAlign.start,
                                    ),
                                    AmountText(
                                      amount: "2.000,00",
                                      fontSize: 8,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Barra de progresso
                                SizedBox(
                                  width: 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Canto arredondado
                                    child: LinearProgressIndicator(
                                      value: progress, // Progresso atual
                                      backgroundColor:
                                          Colors.grey[300], // Cor de fundo
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Colors.green,
                                      ), // Cor do progresso
                                      minHeight: 6, // Altura da barra
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      showSeeMoreText: false,
                      onPressed: () {}),
                  const SizedBox(height: 10),
                  HomePageWidget(
                      titleText: "Receitas",
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const AmountText(
                                    amount: '1.900,00', fontSize: 20),
                                const SizedBox(height: 10),
                                const InfoTile(
                                  valueText: '+ R\$ 14,90',
                                  timeText: '11h45',
                                  iconData: Icons.remove_red_eye_outlined,
                                  valueTextColor: Colors.green,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20, bottom: 2),
                                      child: GestureDetector(
                                        onTap: (){},
                                        child: const Icon(Icons.add_circle_outlined, color: Colors.green, size: 35)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      showSeeMoreText: false,
                      onPressed: () {}),
                  const SizedBox(height: 10),
                  HomePageWidget(
                      titleText: "Despesas",
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const AmountText(
                                    amount: '100,00', fontSize: 20, color: Colors.red,),
                                const SizedBox(height: 10),
                                const InfoTile(
                                  valueText: '- R\$ 100,00',
                                  timeText: '11h45',
                                  iconData: Icons.remove_red_eye_outlined,
                                  valueTextColor: Colors.red,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20, bottom: 2),
                                      child: 
                                      GestureDetector(
                                        onTap: (){},
                                        child: const Icon(Icons.remove_circle_sharp, color: Colors.red, size: 35,)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      showSeeMoreText: false,
                      onPressed: () {}),
                  const SizedBox(height: 20),
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
