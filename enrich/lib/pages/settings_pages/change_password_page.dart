import 'package:enrich/models/setiings.dart';
import 'package:enrich/services/settings_service.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final service = ChangePasswordService();
      final model = ChangePasswordModel(
        senhaAntiga: _oldPasswordController.text,
        senhaNova: _newPasswordController.text,
      );

      final errorMessage = await service.changePassword(model);
      if (errorMessage == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('falha ao alterar senha')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const TitleText(
          text: "Alterar senha",
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo da senha antiga
              TextFormField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Senha antiga',
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha antiga';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo da nova senha
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Nova senha',
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a nova senha';
                  } else if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de confirmação da nova senha
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Confirme a nova senha',
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme a nova senha';
                  } else if (value != _newPasswordController.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),

              ElevatedButton(
                onPressed: _changePassword, // Chama a função de alteração
                child: const Text('Alterar Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
