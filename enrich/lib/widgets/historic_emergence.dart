import 'package:flutter/material.dart';

class HistoricEmergence extends StatelessWidget {
  final Widget icon;
  final String typeText;
  final String time;
  final String amount;
  final Color amountColor;
  final double fontSize;

  const HistoricEmergence({
    super.key,
    required this.icon,
    required this.typeText,
    required this.time,
    required this.amount,
    this.amountColor = Colors.green,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon in circle
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: icon,
        ),
        const SizedBox(width: 12),
        
        // Text and Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              typeText,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: fontSize - 2,
                color: Colors.black,
              ),
            ),
          ],
        ),
        
        Spacer(),
    
        // Amount
        Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
