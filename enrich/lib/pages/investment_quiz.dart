import 'dart:convert';
import 'package:enrich/pages/investment_quiz_result_page.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:flutter/material.dart';

class QuestionData {
  final String questionText;
  final List<String> options;

  QuestionData({required this.questionText, required this.options});
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuestionData> _questions = [
    QuestionData(
      questionText: "Você prefere investimentos com baixo risco e retorno previsível?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você se sente confortável com oscilações no valor dos investimentos?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você já investiu em ações ou criptomoedas antes?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você prefere liquidez imediata nos seus investimentos?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você se preocupa mais com segurança do que com rentabilidade?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você está disposto a investir por longos períodos sem resgatar o dinheiro?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você aceitaria perder parte do investimento para buscar maior rentabilidade?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você tem uma reserva de emergência antes de investir?",
      options: ["Sim", "Não"],
    ),
    QuestionData(
      questionText: "Você já investe regularmente e acompanha o mercado financeiro?",
      options: ["Sim", "Não"],
    ),
  ];

  int _currentStep = 0;
  late List<String> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(_questions.length, '');
  }

  void _responder(String resposta) {
    setState(() {
      _selectedAnswers[_currentStep] = resposta;
      if (_currentStep < _questions.length - 1) {
        _currentStep++;
      } else {
        _enviarRespostas();
      }
    });
  }

  Future<void> _enviarRespostas() async {
    final client = ApiBaseClient();

    final payload = List.generate(_questions.length, (index) {
      return {
        "pergunta_id": index + 1,
        "resposta": _selectedAnswers[index],
      };
    });

    final response = await client.post(
      'investimento/quiz/respostas/',
      body: jsonEncode({"respostas": payload}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => InvestmentQuizResultPage(
          perfil: data['perfil_investidor'],
          sugestoes: List<String>.from(data['sugestoes']),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar respostas do quiz.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pergunta ${_currentStep + 1} de ${_questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(question.questionText, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 24),
          ...question.options.map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ElevatedButton(
                onPressed: () => _responder(option),
                child: Text(option),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
