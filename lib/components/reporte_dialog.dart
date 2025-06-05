import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/noticias/noticias_bloc.dart';
import 'package:psiemens/bloc/noticias/noticias_event.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_event.dart';
import 'package:psiemens/bloc/reportes/reportes_state.dart';
import 'package:psiemens/domain/reporte.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:watch_it/watch_it.dart';

/// Clase para mostrar el diálogo de reportes de noticias
class ReporteDialog {
  /// Muestra un diálogo de reporte para una noticia
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required Noticia noticia,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => di<ReporteBloc>(),
          child: _ReporteDialogContent(
            noticiaId: noticia.id!,
            noticia: noticia,
          ),
        );
      },
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;
  final Noticia noticia;

  _ReporteDialogContent({required this.noticiaId, required this.noticia});

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  bool get noticiaYaReportada => (widget.noticia.contadorReportes ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteBloc>().add(
        CargarEstadisticasReporte(noticia: widget.noticia),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> estadisticas = {
      'NoticiaInapropiada': 0,
      'InformacionFalsa': 0,
      'Otro': 0,
    };
    return BlocConsumer<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteLoading && state.motivoActual == null) {
          // Mostrar diálogo de carga
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is ReporteSuccess) {
          // Mostrar mensaje de éxito
          SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);

          // cerramos el diálogo después de un tiempo
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (state is ReporteError) {
          // Mostrar mensaje de error
          SnackBarHelper.mostrarError(context, mensaje: state.error.message);
        } else if (state is NoticiaReportesActualizada &&
            state.noticia.id == widget.noticiaId) {
          // Actualizar directamente el contador en NoticiaBloc sin hacer petición GET
          context.read<NoticiaBloc>().add(
            ActualizarContadorReportesEvent(
              state.noticia.id!,
              state.contadorReportes,
            ),
          );
        } else if (state is ReporteEstadisticasLoaded) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        // Verificar si estamos en estado de carga y obtener el motivo actual
        final bool isLoading = state is ReporteLoading;
        final motivoActual = isLoading ? (state).motivoActual : null;

        if (state is ReporteEstadisticasLoaded &&
            state.noticia.id == widget.noticiaId) {
          estadisticas = {
            'NoticiaInapropiada':
                state.estadisticas[MotivoReporte.noticiaInapropiada] ?? 0,
            'InformacionFalsa':
                state.estadisticas[MotivoReporte.informacionFalsa] ?? 0,
            'Otro': state.estadisticas[MotivoReporte.otro] ?? 0,
          };
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.gray04, // Color rosa suave
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 70.0,
            vertical: 24.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  noticiaYaReportada ? 'Noticia Reportada' : 'Reportar Noticia',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  noticiaYaReportada
                      ? 'Esta noticia ya ha sido reportada'
                      : 'Selecciona el motivo:',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (noticiaYaReportada)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 48,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Gracias por tu interés en reportar contenido. Esta noticia ya ha sido marcada para revisión.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      // Opciones de reporte con íconos y contadores
                    ),
                  )
                else
                  // Opciones de reporte con íconos y contadores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.noticiaInapropiada,
                        icon: Icons.warning,
                        color: Colors.red,
                        label: 'Inapropiada',
                        iconNumber: '${estadisticas['NoticiaInapropiada']}',
                        isLoading:
                            isLoading &&
                            motivoActual == MotivoReporte.noticiaInapropiada,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.informacionFalsa,
                        icon: Icons.info,
                        color: Colors.amber,
                        label: 'Falsa',
                        iconNumber: '${estadisticas['InformacionFalsa']}',
                        isLoading:
                            isLoading &&
                            motivoActual == MotivoReporte.informacionFalsa,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.otro,
                        icon: Icons.flag,
                        color: Colors.blue,
                        label: 'Otro',
                        iconNumber: '${estadisticas['Otro']}',
                        isLoading:
                            isLoading && motivoActual == MotivoReporte.otro,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: AppColors.text, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotivoButton({
    required BuildContext context,
    required MotivoReporte motivo,
    required IconData icon,
    required Color color,
    required String label,
    required String iconNumber,
    bool isLoading = false,
    bool smallSize = false,
    bool disabled = false,
  }) {
    // Definir tamaños según el parámetro smallSize
    final buttonSize = smallSize ? 50.0 : 60.0;
    final iconSize = smallSize ? 24.0 : 30.0;
    final badgeSize = smallSize ? 16.0 : 18.0;
    final fontSize = smallSize ? 10.0 : 12.0;

    // Si el botón está deshabilitado, no permite la interacción
    final buttonColor = disabled ? Colors.grey.shade300 : Colors.white;
    final iconColor = disabled ? Colors.grey.shade500 : color;

    return Column(
      children: [
        InkWell(
          onTap: (isLoading || disabled) ? null : () => _enviarReporte(context, motivo),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mostrar un indicador de carga si este botón está en proceso
                if (isLoading)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                else
                  Icon(icon, color: iconColor, size: iconSize),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: disabled ? Colors.grey.shade500 : color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        isLoading
                            ? (int.parse(iconNumber) + 1).toString()
                            : iconNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: smallSize ? 6.0 : 8.0),
        Text(
          label, 
          style: TextStyle(
            fontSize: fontSize,
            color: disabled ? Colors.grey.shade500 : null,
          )
        ),
      ],
    );
  }

  void _enviarReporte(BuildContext context, MotivoReporte motivo) {
    // Enviar el reporte usando el bloc directamente
    context.read<ReporteBloc>().add(
      EnviarReporte(noticia: widget.noticia, motivo: motivo),
    );
  }
}
