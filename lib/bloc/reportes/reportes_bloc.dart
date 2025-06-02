import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_event.dart';
import 'package:psiemens/bloc/reportes/reportes_state.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/data/reporte_repository.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/domain/reporte.dart';
import 'package:psiemens/exceptions/api_exception.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository = ReporteRepository();

  ReporteBloc() : super(ReporteInitial()) {
    on<EnviarReporte>(_onEnviarReporte);
    on<CargarEstadisticasReporte>(_onCargarEstadisticasReporte);
  }
  Future<void> _onEnviarReporte(
    EnviarReporte event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      Map<MotivoReporte, int> estadisticasActuales = <MotivoReporte, int>{};
      Noticia noticiaActual = event.noticia;

      // Si ya tenemos estadísticas cargadas, las usamos como base
      if (state is ReporteEstadisticasLoaded) {
        // Crear una copia del mapa de estadísticas actual
        estadisticasActuales = Map<MotivoReporte, int>.from(
          (state as ReporteEstadisticasLoaded).estadisticas,
        );
      }
      // Indicar que estamos procesando el reporte con el motivo específico
      emit(ReporteLoading(motivoActual: event.motivo));

      // 1. Enviar el reporte
      await _reporteRepository.enviarReporte(noticiaActual.id!, event.motivo);
      // 2. Actualizar estadísticas locales
      estadisticasActuales[event.motivo] =
          (estadisticasActuales[event.motivo] ?? 0) + 1;

      // 3. Calcular nuevo contador sumando todos los reportes de todos los tipos
      int totalReportes = 0;
      estadisticasActuales.forEach((motivo, cantidad) {
        totalReportes += cantidad;
      });
      final noticiaActualizada = noticiaActual.copyWith(
        contadorReportes: totalReportes,
      );
      emit(
        NoticiaReportesActualizada(
          noticia: noticiaActualizada,
          contadorReportes: totalReportes,
        ),
      );
      // Emitir un estado de éxito
      emit(const ReporteSuccess(mensaje: ReporteConstantes.reporteCreado));
    } catch (e) {
      if (e is ApiException) {
        emit(ReporteError(e));
      }
    }
  }

  // Método para cargar estadísticas al iniciar
  Future<void> _onCargarEstadisticasReporte(
    CargarEstadisticasReporte event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      emit(const ReporteLoading());
      await _cargarEstadisticas(event.noticia, emit);
    } catch (e) {
      if (e is ApiException) {
        emit(ReporteError(e));
      }
    }
  }

  // Método auxiliar para cargar estadísticas
  Future<void> _cargarEstadisticas(
    Noticia noticia,
    Emitter<ReporteState> emit,
  ) async {
    final estadisticas = await _reporteRepository
        .obtenerEstadisticasReportesPorNoticia(noticia.id!);
    emit(
      ReporteEstadisticasLoaded(noticia: noticia, estadisticas: estadisticas),
    );
  }
}
