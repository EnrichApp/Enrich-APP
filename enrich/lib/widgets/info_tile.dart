import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String valueText;
  final String timeText;
  final IconData iconData;
  final Color valueTextColor;
  final double iconSize;
  final double valueTextSize;
  final double timeTextSize;
  final Color iconColor;
  final double valueToTimeSpacing;
  final double timeToIconSpacing;
  final double width; // Largura padrão definida como 300

  const InfoTile({
    super.key,
    required this.valueText,
    required this.timeText,
    required this.iconData,
    this.valueTextColor = Colors.green,
    this.iconSize = 11,
    this.valueTextSize = 9,
    this.timeTextSize = 9,
    this.iconColor = Colors.grey,
    this.valueToTimeSpacing = 33,
    this.timeToIconSpacing = 12,
    this.width = 160, // Valor padrão da largura
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Aplica a largura especificada ou o valor padrão (300)
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            valueText,
            style: TextStyle(
              color: valueTextColor,
              fontSize: valueTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: valueToTimeSpacing), // Espaçamento entre valor e horário
          Text(
            timeText,
            style: TextStyle(
              color: Colors.black,
              fontSize: timeTextSize,
            ),
          ),
          SizedBox(width: timeToIconSpacing), // Espaçamento entre horário e ícone
          Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
