import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/domain/preferencia.dart';
import 'package:psiemens/bloc/noticias_bloc/noticias_bloc.dart';
import 'package:psiemens/bloc/preferencia_bloc/preferencia_bloc.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';

class PreferenciasScreen extends StatefulWidget {
  const PreferenciasScreen({super.key});

  @override
  State<PreferenciasScreen> createState() => _PreferenciasScreenState();
}

class _PreferenciasScreenState extends State<PreferenciasScreen> {
  late Preferencia _preferenciasTemporales;
  final List<String> _categoriasDisponibles = const [
    'Tecnología',
    'Deportes',
    'Política',
    'Entretenimiento',
    'Economía',
    'Salud'
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar con las preferencias actuales del Bloc
    final state = context.read<PreferenciaBloc>().state;
    _preferenciasTemporales = state.preferencias.copyWith();
  }

  void _toggleCategoria(String categoria) {
    setState(() {
      if (_preferenciasTemporales.categoriasSeleccionadas.contains(categoria)) {
        _preferenciasTemporales.categoriasSeleccionadas.remove(categoria);
      } else {
        _preferenciasTemporales.categoriasSeleccionadas.add(categoria);
      }
    });
  }

  void _guardarPreferencias() {
    context.read<PreferenciaBloc>().add(
          SavePreferencias(_preferenciasTemporales),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _guardarPreferencias,
            tooltip: 'Guardar preferencias',
          ),
        ],
      ),
      body: BlocConsumer<PreferenciaBloc, PreferenciaState>(
        listener: (context, state) {
          if (state is PreferenciaSuccess) {
            // Filtrar noticias con las nuevas preferencias
            context.read<NoticiasBloc>().add(
                  FilterNoticiasByPreferencias(state.preferencias),
                );
            
            // Mostrar feedback y regresar
            SnackBarHelper.showSuccess(
                context, 'Preferencias actualizadas ✓');
            Navigator.pop(context);
          }
          
          if (state is PreferenciaError) {
            SnackBarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is PreferenciaLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return _buildListaCategorias();
        },
      ),
    );
  }

  Widget _buildListaCategorias() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _categoriasDisponibles.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final categoria = _categoriasDisponibles[index];
        return CheckboxListTile(
          title: Text(
            categoria,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          value: _preferenciasTemporales.categoriasSeleccionadas.contains(categoria),
          onChanged: (_) => _toggleCategoria(categoria),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }
}