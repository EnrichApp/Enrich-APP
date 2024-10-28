import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class LittleTextTile extends StatelessWidget {
  final Color iconColor;
  final double iconSize;
  final String text;
  final double fontSize;
  final Icon icon;
  final bool inverted;
  final VoidCallback? onIconTap; // Adicionando o parâmetro para ação ao clicar no ícone

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
            fontSize: 12,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: onIconTap, // Chamando a função se for fornecida
            child: Icon(
              icon.icon,
              color: iconColor,
              size: 10,
            ),
          ),
        ] else ...[
          GestureDetector(
            onTap: onIconTap, // Chamando a função se for fornecida
            child: Icon(
              icon.icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          LittleText(
            text: text,
            fontSize: fontSize,
          ),
        ],
      ],
    );
  }
}
