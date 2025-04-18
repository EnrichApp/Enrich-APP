import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class LittleTextTile extends StatelessWidget {
  final Color iconColor;
  final double iconSize;
  final String text;
  final double fontSize;
  final Widget icon;
  final bool inverted;
  final VoidCallback? onIconTap;

  const LittleTextTile({
    super.key,
    required this.iconColor,
    required this.text,
    required this.icon,
    this.inverted = false,
    this.onIconTap,
    this.iconSize = 12,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (inverted) ...[
          LittleText(
            text: text,
            fontSize: fontSize,
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onIconTap,
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: iconSize),
              child: icon,
            ),
          ),
        ] else ...[
          GestureDetector(
            onTap: onIconTap,
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: iconSize),
              child: icon,
            ),
          ),
          const SizedBox(width: 5),
          LittleText(
            text: text,
            fontSize: fontSize,
          ),
        ],
      ],
    );
  }
}

