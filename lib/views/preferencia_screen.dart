import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/categorias/categorias_bloc.dart';
import 'package:psiemens/bloc/categorias/categorias_event.dart';
import 'package:psiemens/bloc/categorias/categorias_state.dart';
import 'package:psiemens/bloc/preferencia/preferencia_bloc.dart';
import 'package:psiemens/bloc/preferencia/preferencia_event.dart';
import 'package:psiemens/bloc/preferencia/preferencia_state.dart';
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';

class PreferenciasScreen extends StatelessWidget {
  const PreferenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preferencias'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<PreferenciaBloc>().add(const ReiniciarFiltros()),
              tooltip: 'Restablecer filtros',
            ),
          ],
        ),
        body: BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, categoriaState) {
            if (categoriaState is CategoriaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (categoriaState is CategoriaLoaded) {
              return BlocBuilder<PreferenciaBloc, PreferenciaState>(
                builder: (context, preferenciasState) {
                  return _buildListaCategorias(
                    context, 
                    preferenciasState,
                    categoriaState.categorias,
                  );
                },
              );
            } else if (categoriaState is CategoriaError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${categoriaState.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No se pudieron cargar las categorías'));
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<PreferenciaBloc, PreferenciaState>(
          builder: (context, state) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorías seleccionadas: ${state.categoriasSeleccionadas.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ElevatedButton(
                      onPressed: () => _aplicarFiltros(context, state),
                      child: const Text('Aplicar filtros'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListaCategorias(
    BuildContext context, 
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final isSelected = state.categoriasSeleccionadas.contains(categoria.id);
        
        return CheckboxListTile(
          title: Text(
            categoria.nombre,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            categoria.descripcion,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: isSelected,
          onChanged: (_) => _toggleCategoria(context, categoria.id!, isSelected),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  void _toggleCategoria(BuildContext context, String categoriaId, bool isSelected) {
    context.read<PreferenciaBloc>().add(
      CambiarCategoria(
        categoria: categoriaId,
        seleccionada: !isSelected,
      ),
    );
  }

  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    // Siempre devolvemos las categorías seleccionadas, incluso si la lista está vacía
    // Una lista vacía indicará que deben mostrarse todas las noticias
    SnackBarHelper.showSuccess(
      context, 
      state.categoriasSeleccionadas.isEmpty 
        ? 'Mostrando todas las noticias' 
        : 'Filtros aplicados correctamente'
    );
    
    // Devuelve la lista de categorías (vacía o con elementos)
    Navigator.pop(context, state.categoriasSeleccionadas);
  }
}