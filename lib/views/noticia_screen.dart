import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/bloc/bloc%20noticias/noticias_event.dart';
import 'package:psiemens/bloc/bloc%20noticias/noticias_state.dart';
import 'package:psiemens/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:psiemens/bloc/preferencia/preferencia_bloc.dart';
import 'package:psiemens/bloc/preferencia/preferencia_event.dart';
import 'package:psiemens/components/noticia_dialogs.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/helpers/noticia_card_helper.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/helpers/error_helper.dart';
import 'package:psiemens/views/category_screen.dart';
import 'package:psiemens/views/preferencia_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoticiasBloc()..add(const FetchNoticias())),
        BlocProvider(create: (context) => PreferenciaBloc()..add(const CargarPreferencias()))
      ],
      child: BlocConsumer<NoticiasBloc, NoticiasState>(
      listener: (context, state) {
        if (state is NoticiasError) {
          _mostrarError(context, state.statusCode);
        }
      },
      builder: (context, state) {
        // Acceder al estado de preferencias para mostrar información de filtros
        final preferenciaState = context.watch<PreferenciaBloc>().state;
        final filtrosActivos = preferenciaState.categoriasSeleccionadas.isNotEmpty;
        
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Text(NoticiaConstantes.tituloApp),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Agregar Noticia',
                onPressed: () async {
                  try {
                    await NoticiaModal.mostrarModal(
                      context: context,
                      noticia: null,
                      onSave: () {
                        context.read<NoticiasBloc>().add(const FetchNoticias());
                      },
                    );
                  } catch (e) {
                    if (e is ApiException) {
                      _mostrarError(context, e.statusCode);
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
                icon: Icon(Icons.filter_list, 
                  color: filtrosActivos ? Colors.amber : null),
                tooltip: 'Preferencias',
                onPressed: () {
                  Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreferenciasScreen(),
                    ),
                  ).then((categoriasSeleccionadas) {
                    // Verificar si recibimos categorías
                    if (categoriasSeleccionadas != null && categoriasSeleccionadas.isNotEmpty) {
                      // Aplicar filtro con las categorías seleccionadas
                      context.read<NoticiasBloc>().add(
                        FilterNoticiasByPreferencias(categoriasSeleccionadas),
                      );
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refrescar',
                onPressed: () {
                  // Al refrescar, aplicar los filtros actuales si existen
                  final categoriasSeleccionadas = context.read<PreferenciaBloc>().state.categoriasSeleccionadas;
                  if (categoriasSeleccionadas.isNotEmpty) {
                    context.read<NoticiasBloc>().add(
                      FilterNoticiasByPreferencias(categoriasSeleccionadas),
                    );
                  } else {
                    // Si no hay filtros, mostrar todas las noticias
                    context.read<NoticiasBloc>().add(const FetchNoticias());
                  }
                },
              ),
              if (state is NoticiasLoaded)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Text(
                      'Última: ${(DateFormat(NoticiaConstantes.formatoFecha)).format(state.lastUpdated)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Chip para mostrar filtros activos
              if (filtrosActivos)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Filtrado por ${preferenciaState.categoriasSeleccionadas.length} categorías',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Limpiar filtros y mostrar todas las noticias
                          context.read<PreferenciaBloc>().add(const ReiniciarFiltros());
                          context.read<NoticiasBloc>().add(const FetchNoticias());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Limpiar filtros', 
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          ),
        );
      },
    )
    );
  }

  Widget _buildBody(NoticiasState state) {
    if (state is NoticiasLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiasLoaded) {
      final noticias = state.noticiasList;
      if (noticias.isEmpty) {
        return const Center(
          child: Text(NoticiaConstantes.listaVacia),
        );
      } else {
        return ListView.separated(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return NoticiaCardHelper.buildNoticiaCard(
              noticia: noticia,
              onEdit: () async {
                try {
                  await _editarNoticia(context, noticia);
                } catch (e) {
                  if (e is ApiException) {
                    _mostrarError(context, e.statusCode);
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
                    context.read<NoticiasBloc>().add(DeleteNoticia(noticia.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Noticia eliminada'),
                      ),
                    );
                  } catch (e) {
                    if (e is ApiException) {
                      _mostrarError(context, e.statusCode);
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
    }
    // Estado predeterminado o error
    return const Center(
      child: Text('Algo salió mal al cargar las noticias.'),
    );
  }

  Future<void> _editarNoticia(BuildContext context, Noticia noticia) async {
    await NoticiaModal.mostrarModal(
      context: context,
      noticia: noticia.toJson(),
      onSave: () {
        context.read<NoticiasBloc>().add(const FetchNoticias());
      },
    );
  }

  void _mostrarError(BuildContext context, int? statusCode) {
    final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
    final message = errorData['message'];
    final color = errorData['color'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
