import 'package:equatable/equatable.dart';
import 'package:psiemens/domain/task.dart';

/// Eventos para el BLoC de tareas
abstract class TareaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Cargar todas las tareas (con opción de forzar recarga desde API)
class LoadTareasEvent extends TareaEvent {
  final bool forzarRecarga;
  LoadTareasEvent({this.forzarRecarga = true});
  @override
  List<Object?> get props => [forzarRecarga];
}

/// Crear una nueva tarea
class CreateTareaEvent extends TareaEvent {
  final Tarea tarea;
  CreateTareaEvent(this.tarea);
  @override
  List<Object?> get props => [tarea];
}

/// Actualizar una tarea existente
class UpdateTareaEvent extends TareaEvent {
  final Tarea tarea;
  UpdateTareaEvent(this.tarea);
  @override
  List<Object?> get props => [tarea];
}

/// Eliminar una tarea por ID
class DeleteTareaEvent extends TareaEvent {
  final String id;
  DeleteTareaEvent(this.id);
  @override
  List<Object?> get props => [id];
}

/// Evento para marcar una tarea como completada o no completada
class CompletarTareaEvent extends TareaEvent {
  final Tarea tarea;
  final bool completada;
  CompletarTareaEvent(this.tarea, this.completada);
  @override
  List<Object?> get props => [tarea, completada];
}