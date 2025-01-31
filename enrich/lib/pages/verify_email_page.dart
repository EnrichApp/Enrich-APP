import 'dart:convert';

import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/buttons/rounded_text_button.dart';
import '../widgets/form_widget.dart';
import '../widgets/texts/title_text.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // Controllers para os TextFormFields
  final TextEditingController codigoVerificacaoController =
      TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String codigoVerificacao = '';
  final ApiBaseClient apiClient = ApiBaseClient();

  @override
  void dispose() {
    codigoVerificacaoController.dispose();
    super.dispose();
  }

  Future<void> validarCodigoVerificacao(String email, String codigo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');

      final responseValidarCodigo = await apiClient.patch(
        'profile/validar_codigo_verificacao/',
        body: jsonEncode({'email': email, 'codigo': codigo}),
      );

      if (responseValidarCodigo.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('E-mail verificado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacementNamed('/info_to_user_page');
      } else if (responseValidarCodigo.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Código de verificação inválido.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        throw Exception(
            'Erro inesperado. Código: ${responseValidarCodigo.statusCode}');
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Ocorreu algum erro. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String email = arguments?['email'] ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Verifique seu e-mail'),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SubtitleText(
                    text:
                        'Um e-mail foi enviado para $email com um código de verificação. Por favor, insira-o no campo abaixo:'),
              ),
              const SizedBox(height: 15),
              FormWidget(
                hintText: 'Ex.: 123456',
                controller: codigoVerificacaoController,
                onChanged: (value) {
                  setState(() {
                    codigoVerificacao = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Validar E-mail',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () async {
                    await validarCodigoVerificacao(email, codigoVerificacao);
                  }),
            ]),
      ),
    );
  }
}
