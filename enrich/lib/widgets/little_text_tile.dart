import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class LittleTextTile extends StatelessWidget {
  final Color iconColor;
  final double iconSize;
  final String text;
  final double fontSize;
  final Widget icon; // Mantém o nome `icon`, mas agora aceita qualquer widget
  final bool inverted;
  final VoidCallback? onIconTap; // Ação ao clicar no ícone

  const LittleTextTile({
    super.key,
    required this.iconColor,
    required this.text,
    required this.icon, // Mantém o nome `icon`
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
            onTap: onIconTap, // Chamando a função se for fornecida
            child: SizedBox(
              height: iconSize,
              width: iconSize,
              child: icon,
            ),
          ),
        ] else ...[
          GestureDetector(
            onTap: onIconTap, // Chamando a função se for fornecida
            child: SizedBox(
              height: iconSize,
              width: iconSize,
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
