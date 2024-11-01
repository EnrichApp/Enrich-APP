import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/little_text_tile.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo o lucro atual e a meta
    final double currentValue = 1900.00;
    final double targetValue = 2000.00;
    final double progress = currentValue / targetValue;

    final int percentage = 50;

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
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: TitleText(
                text: 'Metas',
                fontSize: 20,
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomePageWidget(
                      titleText: "Comprar um carro",
                      menuIcon: GestureDetector(
                          onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AmountText(
                                    amount: '1.900,00', fontSize: 18),
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
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    LittleTextTile(
                                      iconColor: Colors.green,
                                      text: "Adicionar dinheiro",
                                      icon: Icon(Icons.add_circle_sharp),
                                      iconSize: 24,
                                      fontSize: 9,
                                    ),
                                    SizedBox(width: 5,),
                                    LittleTextTile(
                                      iconColor: Colors.red,
                                      text: "Remover dinheiro",
                                      icon: Icon(Icons.remove_circle_sharp),
                                      iconSize: 24,
                                      fontSize: 9,
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: TitleText(text: "$percentage%", fontSize: 10),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      showSeeMoreText: false,
                      onPressed: () {}),
                  const SizedBox(height: 10),
                  const DottedButton(
                    icon: Icon(Icons.add_circle_outline), // Ícone customizado
                    text: "Adicionar nova meta", // Texto customizado
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
