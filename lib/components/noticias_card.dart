import 'package:flutter/material.dart';
import 'package:psiemens/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/comentarios/comentario_bloc.dart';
import 'package:psiemens/bloc/comentarios/comentario_event.dart';
import 'package:psiemens/bloc/comentarios/comentario_state.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_event.dart';
import 'package:psiemens/bloc/reportes/reportes_state.dart';
import 'package:psiemens/helpers/categoria_helper.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaCard extends StatefulWidget {
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;
  final String imageUrl;
  final String categoriaId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComment;
  final VoidCallback onReport;
  final String categoriaNombre;
  
  const NoticiaCard({
    super.key,
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
    required this.onEdit,
    required this.onDelete,
    required this.categoriaNombre,
    required this.onComment,
    required this.onReport,
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  int _numeroComentarios = 0;
  int _numeroReportes = 0;
  bool _isLoading = true;
  bool _tieneReportes = false;
  final ReporteBloc _reporteBloc = di<ReporteBloc>();

  @override
  void initState() {
    super.initState();
    // Consultar si la noticia tiene reportes
    if (widget.id != null) {
      _reporteBloc.add(ReporteGetByNoticiaEvent(noticiaId: widget.id!));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      if (_isLoading) {
        if (widget.id != null) {
          context.read<ComentarioBloc>().add(
            GetNumeroComentarios(noticiaId: widget.id!),
          );
        }
        _isLoading = false;
      }

      // Verificar estado de comentarios
      final comentarioState = context.watch<ComentarioBloc>().state;
      if (comentarioState is NumeroComentariosLoaded && comentarioState.noticiaId == widget.id) {
        if (_numeroComentarios != comentarioState.numeroComentarios) {
          setState(() {
            _numeroComentarios = comentarioState.numeroComentarios;
          });
        }
      }
      
      // Verificar estado de reportes
      if (widget.id != null) {
        final reporteState = _reporteBloc.state;
        if (reporteState is ReportesPorNoticiaLoaded && 
            reporteState.noticiaId == widget.id) {
          setState(() {
            _numeroReportes = reporteState.reportes.length;
            _tieneReportes = _numeroReportes > 0;
          });
        }
      }
    } catch (e) {
      debugPrint('Error al cargar comentarios o reportes: $e');
    }
  }

  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    // Usar el nuevo helper que implementa la caché de categorías
    return await CategoryHelper.getCategoryName(categoriaId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: NoticiaConstantes.espaciadoAlto,
        horizontal: 16,
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Stack(
          children: [
            // Badge de reportes si tiene alguno
            if (_tieneReportes)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_numeroReportes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Contenido normal de la tarjeta
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.fuente,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.descripcion,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${NoticiaConstantes.publicadaEl} ${widget.publicadaEl}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 1),
                        FutureBuilder<String>(
                          future: _obtenerNombreCategoria(widget.categoriaId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'Cargando...',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(fontSize: 10, color: Colors.red),
                              );
                            }
                            final categoriaNombre =
                                snapshot.data ?? 'Sin categoría';
                            return Text(
                              'Cat: $categoriaNombre',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 120, // Mantenemos el ancho para la columna de imagen y botones
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 24),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 8),
                        // Ajustamos la fila de íconos para evitar overflow
                        SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceEvenly, // Distribuye el espacio uniformemente
                            mainAxisSize:
                                MainAxisSize.max, // Ocupa todo el ancho disponible
                            children: [
                              // Botón de comentarios - más compacto
                              InkWell(
                                onTap: widget.onComment,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$_numeroComentarios',
                                      style: const TextStyle(
                                        fontSize: 15, // Reducimos tamaño de fuente
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 4),

                                    Icon(
                                      Icons.comment,
                                      size: 24, // Reducimos más el tamaño del ícono
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),

                              // Botón de reporte - más compacto
                              GestureDetector(
                                onTap: widget.onReport,
                                child: Icon(
                                  Icons.report,
                                  size: 24, // Tamaño reducido
                                  color: _tieneReportes ? Colors.red : Colors.amber,
                                ),
                              ),

                              // Menú de tres puntos - más compacto
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  size: 24, // Tamaño reducido
                                ),
                                padding: EdgeInsets.zero,
                                iconSize:
                                    18, // Establecemos el tamaño explícitamente
                                itemBuilder:
                                    (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                              size: 18,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Editar',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Eliminar',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    widget.onEdit();
                                  } else if (value == 'delete') {
                                    widget.onDelete();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}