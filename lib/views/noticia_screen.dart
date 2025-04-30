import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/data/noticia_repository.dart';
import 'package:psiemens/components/noticia_dialogs.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/views/categoria_screen.dart';
import 'package:psiemens/helpers/noticia_card_helper.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/helpers/error_helper.dart';
import 'package:psiemens/views/category_screen.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  late Future<List<Noticia>> _noticiasFuture;
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  DateTime? _ultimaActualizacion; // Variable para almacenar la última actualización

  @override
  void initState() {
    super.initState();
    _loadNoticias();
  }

  /// Carga las noticias usando el repositorio.
  void _loadNoticias() {
    _noticiasFuture = _noticiaRepository.obtenerNoticias();
    _actualizarUltimaActualizacion(); // Actualiza la fecha y hora de la última actualización
  }

  /// Refresca la lista de noticias.
  void _refreshNoticias() {
    setState(() {
      _loadNoticias();
    });
  }

  /// Actualiza la fecha y hora de la última actualización.
  void _actualizarUltimaActualizacion() {
    setState(() {
      _ultimaActualizacion = DateTime.now();
    });
  }

  void _mostrarError(ApiException e) {
    final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
    final message = errorData['message'];
    final color = errorData['color'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(NoticiaConstantes.tituloApp),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // Botón para agregar noticia
            tooltip: 'Agregar Noticia',
            onPressed: () async {
              try {
                await NoticiaModal.mostrarModal(
                  context: context,
                  noticia: null,
                  onSave: () {
                    _refreshNoticias();
                    _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
                  },
                );
              } catch (e) {
                if (e is ApiException) {
                  _mostrarError(e);
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categorías',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refrescar',
            onPressed: () {
              _refreshNoticias();
              _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
            },
          ),
          if (_ultimaActualizacion != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Última: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(_ultimaActualizacion!)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _noticiasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (snapshot.error is ApiException) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mostrarError(snapshot.error as ApiException);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error inesperado al cargar noticias.'),
                    backgroundColor: Colors.black,
                  ),
                );
              });
            }
            return const SizedBox.shrink();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay noticias disponibles.'),
            );
          } else {
            final noticias = snapshot.data!;
            return ListView.separated(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return NoticiaCardHelper.buildNoticiaCard(
                  noticia: noticia,
                  onEdit: () async {
                    try {
                      await _editarNoticia(noticia);
                      _refreshNoticias(); // Refresca la lista después de editar una noticia
                      _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
                    } catch (e) {
                      if (e is ApiException) {
                        _mostrarError(e);
                      }
                    }
                  },
                  onDelete: () async {
                    final confirmacion = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Eliminar Noticia'),
                          content: const Text(
                            '¿Estás seguro de que deseas eliminar esta noticia? Esta acción no se puede deshacer.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmacion == true) {
                      try {
                        await _eliminarNoticia(noticia.id); // Llama a la función de eliminación
                        _refreshNoticias(); // Refresca la lista después de eliminar una noticia
                        _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
                      } catch (e) {
                        if (e is ApiException) {
                          _mostrarError(e);
                        }
                      }
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 1,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _editarNoticia(Noticia noticia) async {
    try {
      await NoticiaModal.mostrarModal(
        context: context,
        noticia: noticia.toJson(),
        onSave: () {
          _refreshNoticias();
          _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
        },
      );
    } catch (e) {
      if (e is ApiException) {
        _mostrarError(e);
      }
    }
  }

  Future<void> _eliminarNoticia(String noticiaId) async {
    try {
      await _noticiaRepository.eliminarNoticia(noticiaId);
      _refreshNoticias();
      _actualizarUltimaActualizacion(); // Actualiza la fecha y hora
    } catch (e) {
      if (e is ApiException) {
        _mostrarError(e);
      }
    }
  }
}