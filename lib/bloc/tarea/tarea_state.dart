import 'package:equatable/equatable.dart';
import 'package:psiemens/domain/task.dart';
import 'package:psiemens/exceptions/api_exception.dart';

/// Estados para el BLoC de tareas
abstract class TareaState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TareaInitial extends TareaState {}

/// Estado de carga
class TareaLoading extends TareaState {}

/// Tipos de operación para distinguir el resultado
enum TipoOperacionTarea { cargar, crear, editar, eliminar }

/// Estado de error
class TareaError extends TareaState {
  final ApiException error;
  TareaError(this.error);
  @override
  List<Object?> get props => [error];
}

/// Estado cuando las tareas han sido cargadas
class TareaLoaded extends TareaState {
  final List<Tarea> tareas;
  final DateTime lastUpdated;
  final bool hayMasTareas;
  TareaLoaded({
    required this.tareas,
    required this.lastUpdated,
    this.hayMasTareas = true,
  });
  @override
  List<Object?> get props => [tareas, lastUpdated, hayMasTareas];
}

/// Estado base para operaciones exitosas (crear, editar, eliminar)
class TareaOperationSuccess extends TareaState {
  final List<Tarea> tareas;
  final TipoOperacionTarea tipoOperacion;
  final String mensaje;
  TareaOperationSuccess(this.tareas, this.tipoOperacion, this.mensaje);
  @override
  List<Object?> get props => [tareas, tipoOperacion, mensaje];
}

/// Estado específico para tarea creada
class TareaCreated extends TareaOperationSuccess {
  TareaCreated(super.tareas, super.tipoOperacion, super.mensaje);
}

/// Estado específico para tarea actualizada
class TareaUpdated extends TareaOperationSuccess {
  TareaUpdated(super.tareas, super.tipoOperacion, super.mensaje);
}

/// Estado específico para tarea eliminada
class TareaDeleted extends TareaOperationSuccess {
  TareaDeleted(super.tareas, super.tipoOperacion, super.mensaje);
}