import 'package:enrich/pages/skills_quiz_result_page.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final int steps;
  final List<QuestionData> questions;

  QuizScreen({required this.steps, required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<int?> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<int?>.filled(widget.steps, null); // Inicializa com null
  }

  void _nextStep() {
    if (_currentIndex < widget.steps - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousStep() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _submitAnswers() {
    // Lógica para enviar as respostas
    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SkillsQuizResultPage()),
                );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.steps,
                itemBuilder: (context, index) {
                  final question = widget.questions[index];
                  return QuestionStep(
                    questionData: question,
                    selectedOption: _selectedOptions[index],
                    onOptionSelected: (int? value) {
                      setState(() {
                        _selectedOptions[index] = value;
                      });
                      _nextStep();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _previousStep,
                  ),
                  if (_currentIndex == widget.steps - 1) // Mostra o botão de enviar no último step
                    ElevatedButton(
                      onPressed: _submitAnswers,
                      child: Text("Enviar Respostas"),
                    ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _nextStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionData {
  final String questionText;
  final List<String> options;

  QuestionData({required this.questionText, required this.options});
}

class QuestionStep extends StatelessWidget {
  final QuestionData questionData;
  final int? selectedOption;
  final ValueChanged<int?> onOptionSelected;

  QuestionStep({
    required this.questionData,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            questionData.questionText,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        ...List.generate(questionData.options.length, (index) {
          return RadioListTile<int>(
            value: index,
            groupValue: selectedOption,
            onChanged: onOptionSelected,
            title: Text(
              questionData.options[index],
              style: TextStyle(color: Colors.black),
            ),
          );
        }),
      ],
    );
  }
}