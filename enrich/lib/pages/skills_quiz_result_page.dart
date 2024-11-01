import 'dart:ui';
import 'package:enrich/pages/skills_quiz_page.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class SkillsQuizResultPage extends StatelessWidget {
  const SkillsQuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 14,
              ),
              SizedBox(width: 2),
              LittleText(
                text: 'Voltar',
                fontSize: 12,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confira o seu resultado:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Amanda, de acordo com os resultados do seu teste de habilidades e competências, preparamos uma lista personalizada de recomendações, do mais recomendado ao menos recomendado, para que você considere acrescentar as seguintes fontes de renda extra à sua rotina:',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildRecommendationItem(context, '01 - Desenvolvedor(a) Freelancer', 'Uma boa opção para quem tem habilidades em tecnologia e quer trabalhar de forma independente.'),
                  _buildRecommendationItem(context, '02 - Vendedor(a) de Doces', 'Uma forma de renda extra para quem gosta de cozinhar e quer empreender.'),
                  _buildRecommendationItem(context, '03 - Produtor(a) de Conteúdo Digital', 'Recomendado para quem tem habilidades de comunicação e criatividade.'),
                  _buildRecommendationItem(context, '04 - Professor(a) Particular', 'Ideal para quem tem conhecimento em alguma área e gosta de ensinar.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            RoundedTextButton(
              text: 'Refazer teste de Habilidades e Competências',
              width: 150,
              height: 55,
              fontSize: 12,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SkillsQuizPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(BuildContext context, String title, String infoText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context, infoText),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String infoText) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              infoText,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
