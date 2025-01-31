import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para os TextFormFields
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmacaoSenhaController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String username = '';
  String nome = '';
  String cpf = '';
  String email = '';
  String senha = '';
  String confirmacaoSenha = '';
  String usernameError = '';
  String nomeError = '';
  String cpfError = '';
  String emailError = '';
  String senhaError = '';
  String confirmacaoSenhaError = '';

  final ApiBaseClient apiClient = ApiBaseClient();

  @override
  void dispose() {
    usernameController.dispose();
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmacaoSenhaController.dispose();
    super.dispose();
  }

  bool validarCampos(String email, String cpf, String username, String senha, String confirmacaoSenha) {
    const emailRegex = r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$';
    const cpfRegex = r'^\d{11}$';
    const usernameRegex = r'^[A-Za-z0-9_]+$';
    const senhaRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$'; 

    final Map<String, String?> erros = {
      "email": !RegExp(emailRegex).hasMatch(email) ? 'Insira um e-mail válido.' : null,
      "cpf": !RegExp(cpfRegex).hasMatch(cpf) ? 'Insira um CPF válido (11 dígitos).' : null,
      "username": !RegExp(usernameRegex).hasMatch(username) 
          ? 'O nome de usuário deve conter apenas letras, números e underline, sem espaços.' 
          : null,
      "senha": !RegExp(senhaRegex).hasMatch(senha)
          ? 'A senha deve ter no mínimo 6 caracteres, incluindo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.' 
          : null,
      "confirmacaoSenha": senha != confirmacaoSenha ? 'As senhas devem ser iguais.' : null,
    };

    final errosFiltrados = erros.entries.where((e) => e.value != null).toList();

    if (errosFiltrados.isNotEmpty) {
      setState(() {
        emailError = erros["email"] ?? '';
        cpfError = erros["cpf"] ?? '';
        usernameError = erros["username"] ?? '';
        senhaError = erros["senha"] ?? '';
        confirmacaoSenhaError = erros["confirmacaoSenha"] ?? '';
      });
      return false;
    }

    return true;
  }

  Future<void> registrarUsuario(String username, String nome, String cpf,
      String email, String senha, String confirmacaoSenha) async {
    try {
      if (!validarCampos(email, cpf, username, senha, confirmacaoSenha)) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');

      final response = await apiClient.post(
        'profile/register/',
        body: jsonEncode({
          'username': username,
          'password': senha,
          'primeiro_nome': nome,
          'cpf': cpf,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuário criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        await apiClient.post(
          'profile/enviar_codigo_verificacao/',
          body: jsonEncode({
            'email': email
          }),
        );

        Navigator.of(context).pushNamed(
          '/verify_email_page',
          arguments: {'email': email}
        );
      } else if (response.statusCode == 400) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedBody);

        setState(() {
          usernameError = responseData['username']?.join('\n') ?? '';
          nomeError = responseData['primeiro_nome']?.join('\n') ?? '';
          cpfError = responseData['cpf']?.join('\n') ?? '';
          emailError = responseData['email']?.join('\n') ?? '';
          senhaError = responseData['password']?.join('\n') ?? '';
        });
      } else {
        throw Exception('Erro inesperado. Código: ${response.statusCode}');
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
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TitleText(text: 'Faça seu cadastro'),
            const SizedBox(height: 30),
            FormWidget(
              hintText: 'Digite o seu nome de usuário.',
              controller: usernameController,
              errorText: usernameError, // Passa o erro para o campo
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Digite o seu primeiro nome.',
              controller: nomeController,
              errorText: nomeError,
              onChanged: (value) {
                setState(() {
                  nome = value;
                });
              },
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Digite o seu CPF.',
              controller: cpfController,
              errorText: cpfError,
              onChanged: (value) {
                setState(() {
                  cpf = value;
                });
              },
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Digite o seu e-mail.',
              controller: emailController,
              errorText: emailError,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Digite a sua senha.',
              obscureText: true,
              controller: senhaController,
              errorText: senhaError,
              onChanged: (value) {
                setState(() {
                  senha = value;
                });
              },
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Confirme a sua senha.',
              obscureText: true,
              controller: confirmacaoSenhaController,
              errorText: confirmacaoSenhaError,
              onChanged: (value) {
                setState(() {
                  confirmacaoSenha = value;
                });
              },
            ),
            const SizedBox(height: 15),
            RoundedTextButton(
              text: 'Prosseguir',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () async {
                if (username != '' &&
                    nome != '' &&
                    cpf != '' &&
                    email != '' &&
                    senha != '' &&
                    confirmacaoSenha != '') {
                  await registrarUsuario(
                      username, nome, cpf, email, senha, confirmacaoSenha);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Todos os campos devem ser preenchidos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LittleText(text: 'Já tem uma conta? '),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: LittleText(
                    text: 'Clique aqui.',
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
