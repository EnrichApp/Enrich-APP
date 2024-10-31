import 'package:enrich/pages/investment_quiz_page.dart';
import 'package:enrich/pages/skills_quiz_page.dart';
import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/extra_income_widget.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
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

    // Definindo o lucro atual e a meta
    final double currentValue = 1900.00;
    final double targetValue = 2000.00;
    final double progress = currentValue / targetValue;

    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: ListView(padding: EdgeInsets.zero, children: [
        const SizedBox(
          height: 70,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: TitleText(
            text: 'Renda Extra',
            fontSize: 20,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SkillsQuizPage()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: Text(
              'Ver sugestões personalizadas de fontes de renda extra.',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.green,
                fontSize: 11,
              ),
              textAlign: TextAlign.start,
            ),
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
              const SizedBox(height: 20),
              HomePageWidget(
                  titleText: "Venda de Brigadeiros",
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleText(
                              text: "Lucro do mês atual",
                              textAlign: TextAlign.start,
                              fontSize: 12,
                            ),
                            const AmountText(amount: '1.900,00'),
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
                              width: 150,
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
                  onPressed: () {}),
              const SizedBox(height: 10),
              const DottedButton(
                icon: Icon(Icons.add_circle_outline), // Ícone customizado
                text: "Adicionar nova fonte de renda extra", // Texto customizado
                textSize: 14, // Tamanho do texto customizado
                iconSize: 20, // Tamanho do ícone customizado
              ),             
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
