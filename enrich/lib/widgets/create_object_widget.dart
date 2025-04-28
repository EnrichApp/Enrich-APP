import 'package:flutter/material.dart';

class CreateObjectWidget extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  const CreateObjectWidget({
    Key? key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),
              ...fields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: field,
                  )),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCreateObjectModal({
  required BuildContext context,
  required String title,
  required List<Widget> fields,
  required VoidCallback onSave,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CreateObjectWidget(
      title: title,
      fields: fields,
      onSave: onSave,
      onCancel: onCancel
    ),
  );
}
