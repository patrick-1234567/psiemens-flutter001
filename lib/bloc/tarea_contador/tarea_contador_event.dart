import 'package:equatable/equatable.dart';

abstract class TareaContadorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncrementarContador extends TareaContadorEvent {}
class DecrementarContador extends TareaContadorEvent {}
class SetTotalTareas extends TareaContadorEvent {
  final int total;
  SetTotalTareas(this.total);
  @override
  List<Object?> get props => [total];
}
