import 'package:enrich/pages/financial_planning_page.dart';
import 'package:enrich/pages/home_page.dart';
import 'package:enrich/services/financial_planning_service.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class ChooseFinancialPlanningPage extends StatelessWidget {
  const ChooseFinancialPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiBaseClient();
    final planningService = FinancialPlanningService(apiClient);

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
              padding: EdgeInsets.only(left: 30.0, top: 20.0),
              child: TitleText(
                text: 'Planejamento Financeiro',
                fontSize: 20,
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomePageWidget(
                      height: 165,
                      titleText: "Método das 6 Jarras",
                      content: Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 70,
                                    width: 180,
                                    child: LittleText(
                                      text:
                                          'O Método das 6 Jarras organiza a renda em seis categorias para equilibrar despesas, poupança e investimentos.',
                                      textAlign: TextAlign.left,
                                      fontSize: 11,
                                    )),
                                SizedBox(height: 10),
                                RoundedTextButton(
                                    text: "Gerar automaticamente",
                                    width: 140,
                                    height: 25,
                                    fontSize: 9,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                      );
                                    },
                                    borderColor: null,
                                    borderWidth: 0.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      positionedWidget: Image.asset(
                        'assets/images/6_jars_method.png',
                        height: 115,
                      ),
                      positionedWidgetRight: 23,
                      positionedWidgetTop: 25,
                      showSeeMoreText: false,
                      onPressed: () {}),
                  SizedBox(height: 20),
                  HomePageWidget(
                      height: 195,
                      titleText: "Método 50-30-20",
                      content: Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 100,
                                    width: 160,
                                    child: LittleText(
                                      text:
                                          'O método 50-30-20 divide a renda em 50% para necessidades, 30% para desejos e 20% para poupança ou investimentos.',
                                      textAlign: TextAlign.left,
                                      fontSize: 11,
                                    )),
                                SizedBox(height: 10),
                                RoundedTextButton(
                                    text: "Gerar automaticamente",
                                    width: 140,
                                    height: 25,
                                    fontSize: 9,
                                    onPressed: () async {
                                      // 2. Exibe Loader
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                      try {
                                        // 3. Chama o service
                                        final planning = await planningService
                                            .createTemplate503020();
                                        // 4. Fecha loader e navega
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                FinancialPlanningPage(
                                                    planning: planning),
                                          ),
                                        );
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text('Erro: $e')),
                                        );
                                      }
                                    },
                                    borderColor: null,
                                    borderWidth: 0.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      positionedWidget: Image.asset(
                        'assets/images/50-30-20_method.png',
                        height: 110,
                      ),
                      positionedWidgetRight: 23,
                      positionedWidgetTop: 40,
                      showSeeMoreText: false,
                      onPressed: () {}),
                  const SizedBox(height: 10),
                  DottedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline),
                    text: "Criar planejamento personalizado",
                    textSize: 14,
                    iconSize: 20,
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
