import 'package:flutter/material.dart';

import 'texts/little_text.dart';
import 'texts/title_text.dart';

class HomePageIndicator extends StatelessWidget {
  final Icon icon;
  final String indicator;
  final String value;
  final Color valueTextColor;

  const HomePageIndicator(
      {super.key,
      required this.icon,
      required this.indicator,
      required this.value,
      required this.valueTextColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LittleText(text: indicator),
            TitleText(
              text: value,
              color: valueTextColor,
              fontSize: 17,
            ),
          ],
        )
      ],
    );
  }
}
