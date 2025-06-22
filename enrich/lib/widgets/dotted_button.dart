import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DottedButton extends StatelessWidget {
  final Icon icon; // Ícone recebido como parâmetro
  final String text; // Texto recebido como parâmetro
  final double textSize; // Tamanho do texto
  final double iconSize; // Tamanho do ícone
  final Function onPressed;

  const DottedButton({
    super.key,
    required this.icon, // Ícone é obrigatório
    required this.text, // Texto é obrigatório
    this.textSize = 16, // Tamanho do texto padrão
    this.iconSize = 24, // Tamanho do ícone padrão
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: Colors.grey, // Cor das bordas pontilhadas
          strokeWidth: 1, // Espessura da borda
          dashPattern: const [5, 3], // Definição do padrão das serrilhas
          radius: const Radius.circular(20), // Arredondamento das bordas
        ),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Container(
            height: 50,
            width: double.infinity, // Botão de largura cheia
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Cor de fundo do botão
              borderRadius:
                  BorderRadius.circular(20), // Arredondamento das bordas
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon.icon,
                    size: iconSize, color: Colors.grey), // Ícone personalizado
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: textSize), // Texto personalizado
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
