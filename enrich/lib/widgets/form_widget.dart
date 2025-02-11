import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String hintText;
  final double height;
  final double width;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String errorText;
  final bool multilineError; // <-- Propriedade para erros grandes

  const FormWidget({
    super.key,
    required this.hintText,
    this.height = 55,
    this.width = 300,
    this.obscureText = false,
    required this.controller,
    required this.onChanged,
    this.errorText = '',
    this.multilineError = false, // <-- Inicia como falso por padrão
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: TextFormField(
            onChanged: (value) => onChanged(value),
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: hintText,
              // Só exibe erro se errorText não estiver vazio
              errorText: errorText.isNotEmpty ? errorText : null,

              // Se a propriedade 'multilineError' for true, 
              // deixa quebrar em quantas linhas precisar. 
              // Se for false, fica limitado a 1 (ou 2, 3, etc).
              errorMaxLines: multilineError ? null : 1,

              // Se quiser garantir a quebra em múltiplas linhas, use TextOverflow.clip
              errorStyle: const TextStyle(
                overflow: TextOverflow.clip,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
