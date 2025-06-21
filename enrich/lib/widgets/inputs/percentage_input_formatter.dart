import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2})
      : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text == '') return newValue;

    final value = double.tryParse(text.replaceAll(',', '.'));

    if (value == null) return oldValue;

    // Bloqueia acima de 100.00
    if (value > 100) return oldValue;

    final split = text.split(RegExp(r'[.,]'));

    if (split.length > 1 && split[1].length > decimalRange) {
      return oldValue;
    }

    return newValue;
  }
}

Widget buildPercentField({
  required TextEditingController controller,
  required String label,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[,\.]?\d{0,2}')),
            DecimalTextInputFormatter(decimalRange: 2),
          ],
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            suffixText: '% ao mês',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ],
    ),
  );
}
