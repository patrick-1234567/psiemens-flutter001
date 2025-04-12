import 'package:psiemens/data/question_repository.dart';
import 'package:psiemens/domain/question.dart';

class QuestionService {
  final QuestionRepository _questionRepository;

  QuestionService(this._questionRepository);

  // Método para obtener las preguntas del repositorio
  List<Question> getQuestions() {
    return _questionRepository.getInitialQuestions();
  }
}