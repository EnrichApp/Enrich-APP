import 'package:enrich/pages/investment_quiz_page.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/texts/little_text.dart';
import '../widgets/texts/title_text.dart';

class InvestmentsPage extends StatelessWidget {
  const InvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                titleText: '',
                menuIcon: GestureDetector(
                            onTap: () {}, child: Icon(Icons.more_vert, size: 22)),
                content: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitleText(text: 'R\$29.657,92',),
                      SizedBox(width: 3),
                      LittleText(text: 'investidos.')
                    ],
                  )
                ],),
                showSeeMoreText: false,
                onPressed: () {}
              ),
            )
          ]),
        ));
  }
}
