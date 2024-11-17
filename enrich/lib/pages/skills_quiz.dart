import 'package:enrich/widgets/quiz_screen.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

class SkillsQuiz extends StatefulWidget {
  const SkillsQuiz({super.key});

  @override
  State<SkillsQuiz> createState() => _SkillsQuizState();
}

class _SkillsQuizState extends State<SkillsQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                SizedBox(
                  width: 2,
                ),
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
        body: QuizScreen(
        steps: 3, // número de steps
        questions: [
          QuestionData(
            questionText: "Qual é a capital do Brasil?",
            options: ["Brasília", "Rio de Janeiro", "São Paulo", "Belo Horizonte", "Salvador"],
          ),
          QuestionData(
            questionText: "Qual é a maior montanha do mundo?",
            options: ["Everest", "K2", "Kilimanjaro", "Mont Blanc", "Aconcágua"],
          ),
          QuestionData(
            questionText: "Qual é o oceano mais profundo?",
            options: ["Pacífico", "Atlântico", "Índico", "Ártico", "Antártico"],
          ),
        ],
      ),
    );
  }
}