import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class LittleListTile extends StatelessWidget {
  final Color circleColor;
  final String percentage;
  final String category;

  const LittleListTile(
      {super.key,
      required this.circleColor,
      required this.percentage,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: circleColor,
          size: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        LittleText(
          text: '${category}: ${percentage}',
          fontSize: 12,
        )
      ],
    );
  }
}
