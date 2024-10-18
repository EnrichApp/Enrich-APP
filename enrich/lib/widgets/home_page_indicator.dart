import 'package:flutter/material.dart';

import 'texts/little_text.dart';
import 'texts/title_text.dart';

class HomePageIndicator extends StatelessWidget {
  final Icon icon;
  final String indicator;
  final String value;
  final Color valueTextColor;
  final double spacementValue;

  const HomePageIndicator(
      {super.key,
      required this.icon,
      required this.indicator,
      required this.value,
      required this.valueTextColor,
      this.spacementValue = 0.0,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: spacementValue,
        ),
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
