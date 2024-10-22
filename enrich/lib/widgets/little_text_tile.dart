import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class LittleTextTile extends StatelessWidget {
  final Color iconColor;
  final String text;
  final Icon icon;

  const LittleTextTile(
      {super.key,
      required this.iconColor,
      required this.text,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon.icon,
          color: iconColor,
          size: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        LittleText(
          text: text,
          fontSize: 12,
        )
      ],
    );
  }
}
