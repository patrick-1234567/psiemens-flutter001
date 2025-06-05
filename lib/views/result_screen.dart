import 'package:flutter/material.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/views/game_screen.dart';
import 'package:psiemens/theme/theme.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;
  final double spacingHeight = 20.0;

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final String scoreText = '${GameConstants.finalScore} $finalScore/$totalQuestions';
    final String feedbackMessage = finalScore > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    // Usa los colores del theme
    final Color buttonColor = finalScore > (totalQuestions / 2)
        ? AppColors.primary
        : AppColors.secondary;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scoreText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingHeight),
            Text(
              feedbackMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray07,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(GameConstants.playAgain),
            ),
          ],
        ),
      ),
    );
  }
}