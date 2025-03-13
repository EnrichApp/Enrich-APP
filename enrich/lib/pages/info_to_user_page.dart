import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoToUserPage extends StatefulWidget {
  const InfoToUserPage({super.key});

  @override
  _InfoToUserPageState createState() => _InfoToUserPageState();
}

class _InfoToUserPageState extends State<InfoToUserPage> {
  String? nomeUsuario;
  final ApiBaseClient apiClient = ApiBaseClient();

  @override
  void initState() {
    super.initState();
    _buscarNomeUsuario();
  }

  Future<void> _buscarNomeUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('enrichAppAuthToken');

      if (token == null) {
        throw Exception('Token de autenticação não encontrado.');
      }

      final response = await apiClient.get(
        'profile/me/',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          nomeUsuario = responseData['primeiro_nome'];
        });
      } else {
        throw Exception('Erro ao buscar o nome do usuário.');
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
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
            TitleText(text: 'Olá, ${nomeUsuario ?? 'Usuário'}'),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: SubtitleText(
                text:
                    'Para te ajudarmos a melhorar a sua vida financeira, precisaremos de algumas informações sobre a sua renda atual.',
              ),
            ),
            const SizedBox(height: 15),
            RoundedTextButton(
              text: 'Prosseguir',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () {
                Navigator.of(context).pushNamed('/questions_form_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
