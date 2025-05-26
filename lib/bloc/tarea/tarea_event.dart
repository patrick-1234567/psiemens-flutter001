import 'package:equatable/equatable.dart';
import 'package:psiemens/domain/task.dart';

abstract class TareaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTareasEvent extends TareaEvent {
  final bool forzarRecarga;
  
  LoadTareasEvent({this.forzarRecarga = true});
  
  @override
  List<Object?> get props => [forzarRecarga];
}

class LoadMoreTareasEvent extends TareaEvent {
  final int inicio;
  final int limite;
  
  LoadMoreTareasEvent(this.inicio, this.limite);
  
  @override
  List<Object?> get props => [inicio, limite];
}

class CreateTareaEvent extends TareaEvent {
  final Tarea tarea;
  
  CreateTareaEvent(this.tarea);
  
  @override
  List<Object?> get props => [tarea];
}

class UpdateTareaEvent extends TareaEvent {
  final Tarea tarea;
  
  UpdateTareaEvent(this.tarea);
  
  @override
  List<Object?> get props => [tarea];
}

class DeleteTareaEvent extends TareaEvent {
  final String id;
  
  DeleteTareaEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}