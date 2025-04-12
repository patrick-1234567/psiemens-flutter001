import 'package:flutter/material.dart';
import '../api/service/question_service.dart';
import '../data/question_repository.dart';
import '../domain/question.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late QuestionService questionService;
  late List<Question> questionsList;
  int currentQuestionIndex = 0; // Índice de la pregunta actual
  int userScore = 0; // Puntaje del usuario
  final double spacingHeight = 16.0; // Espaciado entre elementos
  int? selectedAnswerIndex; // Índice de la respuesta seleccionada
  bool? isCorrectAnswer; // Estado para manejar si la respuesta es correcta

  @override
  void initState() {
    super.initState();
    questionService = QuestionService(QuestionRepository());
    questionsList = questionService.getQuestions(); // Obtiene la lista de preguntas
  }

  void _answerQuestion(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      isCorrectAnswer = selectedIndex == questionsList[currentQuestionIndex].correctAnswerIndex;

      // Incrementa el puntaje si la respuesta es correcta
      if (isCorrectAnswer == true) {
        userScore++;
      }
    });

    // Retraso antes de navegar a la siguiente pregunta o a la pantalla de resultados
    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++; // Avanza a la siguiente pregunta
          selectedAnswerIndex = null; // Reinicia el índice seleccionado
          isCorrectAnswer = null; // Reinicia el estado de la respuesta
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(userScore: userScore), // Navega a la pantalla de resultados
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questionsList[currentQuestionIndex];
    final questionCounterText =
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        title: Text(
          questionCounterText,
          style: const TextStyle(color: Colors.black), // Texto negro
        ),
        backgroundColor: Colors.white, // Fondo blanco
        iconTheme: const IconThemeData(color: Colors.blue), // Íconos azules
        elevation: 0, // Sin sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Texto negro
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingHeight), // Espaciado entre la pregunta y las opciones
            ...currentQuestion.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Espaciado entre botones
                child: ElevatedButton(
                  onPressed: selectedAnswerIndex == null
                      ? () => _answerQuestion(index)
                      : null, // Desactiva los botones después de seleccionar
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Texto blanco
                    backgroundColor: selectedAnswerIndex == index
                        ? (isCorrectAnswer == true ? Colors.green : Colors.red) // Verde si es correcta, rojo si no
                        : Colors.blue, // Fondo azul por defecto
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 16), // Tamaño de texto
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