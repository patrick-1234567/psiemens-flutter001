import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_event.dart';
import 'package:psiemens/bloc/reportes/reportes_state.dart';
import 'package:psiemens/domain/reporte.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';

/// Componente de diálogo para reportar noticias
class ReporteDialog {
  /// Muestra un diálogo para reportar una noticia con botones para cada tipo de motivo
  /// y un contador de reportes por cada tipo
  static Future<void> mostrarDialogoReporte(
    BuildContext context,
    String noticiaId,
  ) async {
    // Obtener una instancia fresca del ReporteBloc
    final reporteBloc = di<ReporteBloc>();

    // Primero cargamos los reportes existentes para esta noticia
    reporteBloc.add(ReporteGetByNoticiaEvent(noticiaId: noticiaId));

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: reporteBloc,
          child: BlocConsumer<ReporteBloc, ReporteState>(
            listener: (context, state) {
              if (state is ReporteCreated) {
                SnackBarHelper.showSuccess(
                  context,
                  'Reporte enviado correctamente',
                );
                Navigator.of(context).pop();
              } else if (state is ReporteError) {
                SnackBarHelper.showClientError(
                  context,
                  'Error al enviar el reporte: ${state.message}',
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                title: const Text(
                  'Reportar Noticia',
                  style: TextStyle(color: Colors.black87),
                ),
                backgroundColor: const Color(0xFFF5F5F5), // Fondo gris claro
                content: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seleccione el motivo del reporte:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Mostrar un CircularProgressIndicator durante la carga
                      if (state is ReporteLoading)
                        const Center(child: CircularProgressIndicator())
                      // Mostrar los botones con contadores si ya se cargaron los reportes
                      else if (state is ReportesPorNoticiaLoaded)
                        _buildReporteButtons(context, state, noticiaId)
                      // Mostrar botones sin contadores si aún no hay datos o hay error
                      else
                        _buildReporteButtonsDefault(context, noticiaId),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Colors.blue, // Color azul para el texto del botón
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      backgroundColor:
                          HSVColor.fromColor(Colors.blue)
                              .withValue(0.97) // Valor alto para hacerlo claro
                              .withSaturation(
                                0.1,
                              ) // Saturación baja para hacerlo menos intenso
                              .toColor(), // Fondo azul claro
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.blue, width: 1),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              );
            },
          ),
        );
      },
    );
  }

  // Widget para construir los botones con contadores
  static Widget _buildReporteButtons(
    BuildContext context,
    ReportesPorNoticiaLoaded state,
    String noticiaId,
  ) {
    // Contar reportes por motivo
    Map<MotivoReporte, int> contadorMotivos = {};

    // Inicializar contador para todos los tipos de motivo
    for (var motivo in MotivoReporte.values) {
      contadorMotivos[motivo] = 0;
    }

    // Contar reportes existentes por motivo
    for (var reporte in state.reportes) {
      contadorMotivos[reporte.motivo] =
          (contadorMotivos[reporte.motivo] ?? 0) + 1;
    }

    return Column(
      children:
          MotivoReporte.values.map((motivo) {
            // Texto que se mostrará en el botón
            String motivoText = _getMotivoText(motivo);
            int contador = contadorMotivos[motivo] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(_getMotivoIcon(motivo)),
                  label: Text('$motivoText ($contador)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMotivoColor(motivo),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _enviarReporte(context, noticiaId, motivo);
                  },
                ),
              ),
            );
          }).toList(),
    );
  }

  // Widget para construir los botones sin datos cargados
  static Widget _buildReporteButtonsDefault(
    BuildContext context,
    String noticiaId,
  ) {
    return Column(
      children:
          MotivoReporte.values.map((motivo) {
            String motivoText = _getMotivoText(motivo);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(_getMotivoIcon(motivo)),
                  label: Text('$motivoText (0)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMotivoColor(motivo),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _enviarReporte(context, noticiaId, motivo);
                  },
                ),
              ),
            );
          }).toList(),
    );
  }

  // Método para enviar el reporte
  static void _enviarReporte(
    BuildContext context,
    String noticiaId,
    MotivoReporte motivo,
  ) {
    context.read<ReporteBloc>().add(
      ReporteCreateEvent(noticiaId: noticiaId, motivo: motivo),
    );
  }

  // Función para obtener el texto del motivo
  static String _getMotivoText(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return 'Noticia Inapropiada';
      case MotivoReporte.informacionFalsa:
        return 'Información Falsa';
      case MotivoReporte.otro:
        return 'Otro Motivo';
    }
  }

  // Función para obtener ícono según el tipo de motivo
  static IconData _getMotivoIcon(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return Icons.warning;
      case MotivoReporte.informacionFalsa:
        return Icons.dangerous;
      case MotivoReporte.otro:
        return Icons.help_outline;
    }
  }

  // Función para obtener color según el tipo de motivo
  static Color _getMotivoColor(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return Colors.orange;
      case MotivoReporte.informacionFalsa:
        return Colors.red.shade700;
      case MotivoReporte.otro:
        return Colors.blue;
    }
  }
}
