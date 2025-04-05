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

    const double horizontalPadding = 30;

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
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: 'Planejamento Financeiro',
                  fontSize: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.more_vert)
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 170,
                width: 130,
                child: SfCircularChart(series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ]),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: 'Total planejado',
                    fontSize: 13,
                  ),
                  TitleText(
                    text: 'R\$ 4200,00',
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  LittleText(
                    text: 'R\$ 0,00 não planejados',
                    fontSize: 13,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: horizontalPadding),
            child: TitleText(
              text: 'Caixinhas',
              fontSize: 17,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              color: Colors.white,
              height: 70,
              child: Center(
                child: ListTile(
                  onTap: () {},
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TitleText(
                        text: '50%',
                        fontSize: 17,
                        color: Colors.purple,
                      ),
                      TitleText(
                        text: 'R\$2000,00',
                        fontSize: 15,
                      )
                    ],
                  ),
                  leading: ClipOval(
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            color: Colors.purple,
                            width: 45,
                            height: 45,
                          ),
                          Image.asset(
                            'assets/images/planning_page_jar.png',
                            height: 23,
                            width: 23,
                          ),
                        ]),
                  ),
                  title: TitleText(
                    text: 'Essenciais',
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              color: Colors.white,
              height: 70,
              child: Center(
                child: ListTile(
                  onTap: () {},
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TitleText(
                        text: '10%',
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                      TitleText(
                        text: 'R\$2000,00',
                        fontSize: 15,
                      )
                    ],
                  ),
                  leading: ClipOval(
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            color: Colors.blue,
                            width: 45,
                            height: 45,
                          ),
                          Image.asset(
                            'assets/images/planning_page_jar.png',
                            height: 23,
                            width: 23,
                          ),
                        ]),
                  ),
                  title: TitleText(
                    text: 'Lazer',
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              color: Colors.white,
              height: 70,
              child: Center(
                child: ListTile(
                  onTap: () {},
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TitleText(
                        text: '0%',
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                      TitleText(
                        text: 'R\$0,00',
                        fontSize: 15,
                      )
                    ],
                  ),
                  leading: ClipOval(
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            color: Colors.grey,
                            width: 45,
                            height: 45,
                          ),
                          Image.asset(
                            'assets/images/planning_page_jar.png',
                            height: 23,
                            width: 23,
                          ),
                        ]),
                  ),
                  title: TitleText(
                    text: 'Não planejado',
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
