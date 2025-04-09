class Task {
  final String title;
  final String type;
  final DateTime deadline;
  final String description;
  List<String> steps;
  
  Task({
    required this.title,
    this.type = 'normal',
    required this.deadline,
    this.description = '',
    this.steps = const [],
    });
}