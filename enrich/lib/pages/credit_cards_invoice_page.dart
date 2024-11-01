import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class CreditCardsInvoicePage extends StatelessWidget {
  const CreditCardsInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo o lucro atual e a meta
    final String finalDate = "29/09/2024";
    final String status = "Em atraso";
    final String amount = "R\$180,00";

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
                text: 'Faturas de Cartão',
                fontSize: 20,
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomePageWidget(
                      titleText: "Cartão de Crédito Nubank",
                      menuIcon: GestureDetector(
                          onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(
                                    text: "Fatura Atual", fontSize: 12),
                                SubtitleText(
                                  text: "Data final: $finalDate",
                                  fontSize: 10,
                                ),
                                SubtitleText(
                                  text: "Status: $status",
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                                SubtitleText(
                                  text: "Valor: $amount",
                                  fontSize: 10,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    RoundedTextButton(
                                        text: "Fatura Paga",
                                        width: 90,
                                        height: 20,
                                        fontSize: 9,
                                        onPressed: () {},
                                        borderColor: null,
                                        borderWidth: 0.0),
                                    SizedBox(width: 7),
                                    RoundedTextButton(
                                      text: "Prazo de pagamento excedido",
                                      width: 170,
                                      height: 20,
                                      fontSize: 9,
                                      onPressed: () {},
                                      borderColor: null,
                                      borderWidth: 0.0,
                                      buttonColor: Colors.red,
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
                      SizedBox(height: 20),
                      HomePageWidget(
                      titleText: "Cartão de Crédito PicPay",
                      menuIcon: GestureDetector(
                          onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(
                                    text: "Fatura Atual", fontSize: 12),
                                SubtitleText(
                                  text: "Data final: $finalDate",
                                  fontSize: 10,
                                ),
                                SubtitleText(
                                  text: "Status: $status",
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                                SubtitleText(
                                  text: "Valor: $amount",
                                  fontSize: 10,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    RoundedTextButton(
                                        text: "Fatura Paga",
                                        width: 90,
                                        height: 20,
                                        fontSize: 9,
                                        onPressed: () {},
                                        borderColor: null,
                                        borderWidth: 0.0),
                                    SizedBox(width: 7),
                                    RoundedTextButton(
                                      text: "Prazo de pagamento excedido",
                                      width: 170,
                                      height: 20,
                                      fontSize: 9,
                                      onPressed: () {},
                                      borderColor: null,
                                      borderWidth: 0.0,
                                      buttonColor: Colors.red,
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
                    text: "Adicionar nova fatura", // Texto customizado
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
