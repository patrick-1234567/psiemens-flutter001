import 'package:flutter/material.dart';
import '../constants.dart';
import 'start_screen.dart';
import 'game_screen.dart';
class ResultScreen extends StatelessWidget {
  final int finalScore; // Puntaje final
  final int totalQuestions; // Total de preguntas
  final double spacingHeight = 20.0; // Espaciado entre elementos

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    // Texto del puntaje
    final String scoreText = '${GameConstants.finalScore} $finalScore/$totalQuestions';

    // Mensaje de retroalimentación
    final String feedbackMessage = finalScore > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    // Determina el color del botón
    final Color buttonColor = finalScore > (totalQuestions / 2)
        ? Colors.blue // Azul si el puntaje es mayor a la mitad
        : Colors.green; // Verde en caso contrario

    // Estilo del texto del puntaje
    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    // Estilo del mensaje de retroalimentación
    const TextStyle feedbackTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey,
    );

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        elevation: 0, // Sin sombra
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scoreText,
              style: scoreTextStyle, // Estilo del puntaje
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingHeight), // Espaciado entre puntaje y mensaje
            Text(
              feedbackMessage,
              style: feedbackTextStyle, // Estilo del mensaje de retroalimentación
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32), // Espaciado entre mensaje y botón
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Usa el color determinado
                foregroundColor: Colors.white, // Texto blanco
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(GameConstants.playAgain),
            ),
          ],
        ),
      ),
    );
  }
}