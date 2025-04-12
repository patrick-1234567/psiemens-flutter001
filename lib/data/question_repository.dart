import '../domain/question.dart';

class QuestionRepository {
  // Método para obtener preguntas iniciales
  List<Question> getInitialQuestions() {
    return [
      Question(
        questionText: '¿Cuál es la capital de Francia?',
        answerOptions: ['Madrid', 'París', 'Roma'],
        correctAnswerIndex: 1, // París
      ),
      Question(
        questionText: '¿Cuál es el planeta más cercano al Sol?',
        answerOptions: ['Venus', 'Marte', 'Mercurio'],
        correctAnswerIndex: 2, // Mercurio
      ),
      Question(
        questionText: '¿Cuántos continentes hay en el mundo?',
        answerOptions: ['5', '6', '7'],
        correctAnswerIndex: 2, // 7
      ),
      Question(
        questionText: '¿Qué planeta es conocido como el planeta rojo?',
        answerOptions: ['Júpiter', 'Marte', 'Venus'],
        correctAnswerIndex: 1, // Marte
      ),
    ];
  }
}