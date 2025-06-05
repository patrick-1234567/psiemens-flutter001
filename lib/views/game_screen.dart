import 'package:flutter/material.dart';
import 'package:psiemens/api/service/question_service.dart';
import 'package:psiemens/data/question_repository.dart';
import 'package:psiemens/domain/question.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:psiemens/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late QuestionService questionService;
  late List<Question> questionsList;
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedAnswerIndex;
  bool? isCorrectAnswer;
  Color? selectedButtonColor;

  @override
  void initState() {
    super.initState();
    questionService = QuestionService(QuestionRepository());
    questionsList = questionService.getQuestions();
    selectedButtonColor = AppColors.primary;
  }

  void _answerQuestion(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      isCorrectAnswer = selectedIndex == questionsList[currentQuestionIndex].correctAnswerIndex;
      selectedButtonColor = isCorrectAnswer == true ? Colors.green : Colors.red;

      if (isCorrectAnswer == true) {
        userScore++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (currentQuestionIndex < questionsList.length - 1) {
          setState(() {
            currentQuestionIndex++;
            selectedAnswerIndex = null;
            isCorrectAnswer = null;
            selectedButtonColor = AppColors.primary;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                finalScore: userScore,
                totalQuestions: questionsList.length,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questionsList[currentQuestionIndex];
    final questionCounterText = 'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(questionCounterText, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.questionText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...currentQuestion.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isSelected = selectedAnswerIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isSelected ? selectedButtonColor : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: selectedAnswerIndex == null ? () => _answerQuestion(index) : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          answer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}