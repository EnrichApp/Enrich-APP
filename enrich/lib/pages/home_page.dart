import 'dart:convert';

import 'package:enrich/widgets/home_page_indicator.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/little_list_tile.dart';
import '../widgets/texts/title_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
            ChartData('David', 25),
            ChartData('Steve', 38),
            ChartData('Jack', 34),
            ChartData('Others', 52)
    ];
    return Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.onSurface,
          child: Column(
                children: [
          Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              const TitleText(
                text: 'Olá, Amanda!',
                fontSize: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(
                    text: 'Setembro - 2024',
                    fontSize: 13,
                  ),
                  GestureDetector(
                    child: Icon(Icons.keyboard_arrow_down),
                    onTap: () {},
                  )
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomePageIndicator(
                    icon: Icon(
                      Icons.north,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40,
                    ),
                    indicator: 'Ganhos',
                    value: 'R\$1500',
                    valueTextColor: Theme.of(context).colorScheme.secondary,
                  ),
                  HomePageIndicator(
                    icon: Icon(
                      Icons.south,
                      color: Theme.of(context).colorScheme.surface,
                      size: 40,
                    ),
                    indicator: 'Gastos',
                    value: 'R\$ 700',
                    valueTextColor: Theme.of(context).colorScheme.surface,
                  ),
                  const HomePageIndicator(
                    icon: Icon(
                      Icons.wallet_sharp,
                      color: Colors.black,
                      size: 40,
                    ),
                    indicator: 'Gastos',
                    value: 'R\$ 700',
                    valueTextColor: Colors.black,
                    spacementValue: 5.0,
                  ),
                ],
              )
            ]),
          ),
          const SizedBox(height: 30),
          Container(
            height: 150,
            width: 320,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 14.0),
                  child: TitleText(
                    text: 'Planejamento Financeiro',
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                            height: 110,
                            width: 100,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                    PieSeries<ChartData, String>(
                                        dataSource: chartData,
                                        pointColorMapper:(ChartData data, _) => data.color,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y
                                    )
                                ]
                            ),
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
                    ],)
                  ],
                ),
              ],
            ),
          )
                ],
              ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}