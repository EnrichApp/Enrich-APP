import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String hintText;
  final double height;
  final double width;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String errorText;

  const FormWidget({
    super.key,
    required this.hintText,
    this.height = 55,
    this.width = 300,
    this.obscureText = false,
    required this.controller,
    required this.onChanged,
    this.errorText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: TextFormField(
            onChanged: (value) {
              onChanged(value);
            },
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: hintText,
              errorText: errorText.isNotEmpty ? errorText : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ],
    );
  }
}
