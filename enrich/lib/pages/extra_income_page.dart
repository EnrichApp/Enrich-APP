import 'package:enrich/widgets/extra_income_widget.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExtraIncomePage extends StatelessWidget {
  const ExtraIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Janeiro', 18, Colors.green),
      ChartData('Fevereiro', 26, Colors.green),
      ChartData('Março', 23, Colors.green),
      ChartData('Abril', 30, Colors.green),
      ChartData('Maio', 40, Colors.green),
    ];
    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: ListView(padding: EdgeInsets.zero, children: [
        const SizedBox(height: 30,),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: TitleText(
            text: 'Renda Extra',
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          color: Theme.of(context).colorScheme.onSurface,
          child: Column(
            children: [
              // TODO link teste
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
              const SizedBox(height: 20),
              HomePageWidget(
                  titleText: "Venda de Brigadeiros",
                  content: const SizedBox(height: 10),
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
