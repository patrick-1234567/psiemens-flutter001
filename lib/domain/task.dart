class Task {
  final String title;
  final String type;
  final DateTime fechaLimite;
  List<String> pasos = [];
  
  Task({
    required this.title,
    this.type = 'normal',
    required this.fechaLimite,
    });
}