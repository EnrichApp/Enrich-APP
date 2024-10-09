import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String hintText;
  final double height;
  final double width;
  final bool obscureText;
  final TextEditingController controller;
  final Function onChanged;

  const FormWidget(
      {super.key,
      required this.hintText,
      this.height = 55,
      this.width = 300,
      this.obscureText = false,
      required this.controller,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        onChanged: (value) {
          onChanged(value);
        },
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
