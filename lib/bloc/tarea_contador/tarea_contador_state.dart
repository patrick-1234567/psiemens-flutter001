import 'package:equatable/equatable.dart';

class TareaContadorState extends Equatable {
  final int completadas;
  const TareaContadorState({required this.completadas});

  TareaContadorState copyWith({int? completadas}) {
    return TareaContadorState(
      completadas: completadas ?? this.completadas,
    );
  }

  @override
  List<Object?> get props => [completadas];
}
