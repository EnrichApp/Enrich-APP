import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CircularIcon({
    super.key,
    required this.iconData,
    this.size = 40.0, // Tamanho padrão do círculo
    this.backgroundColor = Colors.grey, // Cor de fundo padrão
    this.iconColor = Colors.white, // Cor padrão do ícone
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: size * 0.5, // Ajusta o tamanho do ícone em relação ao círculo
        ),
      ),
    );
  }
}
