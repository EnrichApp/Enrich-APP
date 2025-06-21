import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildMonthYearPickerField({
  required TextEditingController controller,
  required String label,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            int selectedYear = now.year;
            int selectedMonth = now.month;

            await showDialog(
              context: context,
              builder: (_) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: AlertDialog(
                    title: const Text(
                      'Selecione mês e ano',
                      style: TextStyle(color: Colors.black),
                    ),
                    content: StatefulBuilder(
                      builder: (ctx, setState) {
                        return SizedBox(
                          height: 130,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DropdownButton<int>(
                                    dropdownColor: Colors.white,
                                    style:
                                        const TextStyle(color: Colors.black),
                                    value: selectedMonth,
                                    items: List.generate(12, (index) {
                                      final month = index + 1;
                                      return DropdownMenuItem(
                                        value: month,
                                        child: Text(
                                          DateFormat.MMMM('pt_BR')
                                              .format(DateTime(0, month)),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => selectedMonth = val);
                                      }
                                    },
                                  ),
                                  DropdownButton<int>(
                                    dropdownColor: Colors.white,
                                    style:
                                        const TextStyle(color: Colors.black),
                                    value: selectedYear,
                                    items: List.generate(10, (index) {
                                      final year = now.year + index;
                                      return DropdownMenuItem(
                                        value: year,
                                        child: Text(
                                          '$year',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => selectedYear = val);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  final mesAno =
                                      '${selectedMonth.toString().padLeft(2, '0')}/$selectedYear';
                                  controller.text = mesAno;
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
