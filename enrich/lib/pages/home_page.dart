import 'dart:convert';

import 'package:enrich/widgets/home_page_indicator.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';

import '../widgets/texts/title_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 20,),
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
              ],
            )
          ]),
        ),
      ],
    ));
  }
}
