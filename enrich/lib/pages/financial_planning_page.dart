import 'package:enrich/pages/goals_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';

class FinancialPlanningPage extends StatelessWidget {
  const FinancialPlanningPage({super.key});

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
          child: ListView(
            padding: EdgeInsets.zero, children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 20.0),
              child: TitleText(
                text: 'Planejamento Financeiro',
                fontSize: 20,
              ),
            ),
            SfCircularChart(series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
            ]),
          ]),
      ),
    );
  }
}