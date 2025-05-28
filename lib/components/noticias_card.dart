import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_event.dart';
import 'package:psiemens/bloc/reportes/reportes_state.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/views/comentarios/comentarios_screen.dart';
import 'package:psiemens/components/reporte_dialog.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit; // Callback para editar la noticia
  final String
  categoriaNombre; // Nuevo parámetro para mostrar el nombre de la categoría
  final VoidCallback? onReport; // Callback para reportar la noticia

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(
            top: 16.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
          ), // Margen de la tarjeta
          color: Colors.white,
          shape: null,
          elevation: 0.0,
          child: Column(
            children: [              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    categoriaNombre,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Primera fila: Texto y la imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna para el texto (2/3 del ancho)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noticia.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            noticia.descripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            noticia.fuente,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            _formatDate(noticia.publicadaEl),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        noticia.urlImagen.isNotEmpty
                            ? noticia.urlImagen
                            : 'https://via.placeholder.com/100', // Imagen por defecto si no hay URL
                        height: 80, // Altura de la imagen
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Widget alternativo cuando la imagen no carga
                          return Container(
                            height: 80,
                            width: 100,
                            color: Colors.grey[300], // Fondo gris claro
                            child: const Icon(
                              Icons.broken_image, // Ícono de imagen rota
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Alinea los botones al final
                children: [                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      // Navegar a la vista de comentarios
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ComentariosScreen(
                                noticiaId: noticia.id!,
                                noticiaTitulo: noticia.titulo,
                              ),
                        ),
                      );                    },
                    tooltip: 'Ver comentarios',
                  ),                  // Botón de reportar con ícono de warning
                  BlocProvider(
                    create: (context) => di<ReporteBloc>()..add(CargarEstadisticasReporte(noticiaId: noticia.id!)),
                    child: BlocBuilder<ReporteBloc, ReporteState>(
                      builder: (context, state) {
                        // Calcular el total de reportes
                        int totalReportes = 0;
                        bool isLoading = state is ReporteLoading;
                        
                        if (state is ReporteEstadisticasLoaded && state.noticiaId == noticia.id) {
                          // Sumar todos los reportes de diferentes tipos
                          totalReportes = state.estadisticas.values.fold(0, (sum, value) => sum + value);
                        }
                        
                        // Determinar el color basado en el número de reportes
                        Color iconColor;
                        
                        if (totalReportes == 0) {
                          iconColor = Colors.grey;
                        } else if (totalReportes < 5) {
                          iconColor = Colors.orange;
                        } else {
                          iconColor = Colors.red;
                        }
                        
                        return IconButton(
                          icon: Icon(
                            Icons.warning,
                            color: iconColor,
                          ),
                          onPressed: isLoading ? null : () {
                            if (onReport != null) {
                              onReport!();
                            } else {
                              ReporteDialog.mostrarDialogoReporte(
                                context: context,
                                noticiaId: noticia.id!,
                              );
                            }
                          },
                          tooltip: 'Reportar noticia',
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para mostrar más opciones
                      onEdit();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 17.0,
            vertical: 0.0,
          ), // Padding horizontal de 16
          child: Divider(color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstants.formatoFecha).format(date);
  }
}
