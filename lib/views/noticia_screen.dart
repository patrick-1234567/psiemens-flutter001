// lib/views/noticia_screen.dart
import 'package:flutter/material.dart';
import 'package:psiemens/api/service/noticia_service.dart'; // Ajusta la ruta
import 'package:psiemens/constants.dart';                  // Ajusta la ruta
import 'package:psiemens/data/noticia_repository.dart';    // Ajusta la ruta
import 'package:psiemens/domain/noticia.dart';             // Ajusta la ruta
import 'package:psiemens/helpers/noticia_card_helper.dart'; // Ajusta la ruta

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  State<NoticiaScreen> createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  // --- State Variables ---
  final List<Noticia> _noticias = [];
  late NoticiaService _noticiaService;
  final ScrollController _scrollController = ScrollController();

  // Ya no necesitamos _currentPage para la paginación tradicional
  // int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    // --- Inicialización ---
    final noticiaRepository = NoticiaRepository();
    _noticiaService = NoticiaService(noticiaRepository);

    // --- Carga inicial ---
    _cargarNoticias(isInitialLoad: true);

    // --- Listener para scroll infinito ---
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _isLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Llama a cargar noticias, pero ya no es la carga inicial
      _cargarNoticias();
    }
  }

  /// Carga noticias desde el servicio. Usa obtenerNoticiasPaginadas para la carga
  /// inicial y cargarMasNoticias para las cargas subsiguientes (scroll).
  Future<void> _cargarNoticias({bool isInitialLoad = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isInitialLoad) {
        _error = null;
        _noticias.clear();
        // _currentPage = 1; // Ya no es necesario
        _hasMore = true;
      }
    });

    try {
      List<Noticia> nuevasNoticias;

      if (isInitialLoad) {
        // --- Carga Inicial ---
        nuevasNoticias = await _noticiaService.obtenerNoticiasPaginadas(
          numeroPagina: 1, // Siempre la página 1 para la carga inicial
          tamanoPagina: NoticiaConstantes.tamanoPagina,
        );
      } else {
        // --- Cargar Más (Scroll) ---
        nuevasNoticias = await _noticiaService.cargarMasNoticias(
          cantidad: NoticiaConstantes.tamanoPagina, // Carga el siguiente lote
          indiceActual: _noticias.length, // Pasa cuántas noticias ya tenemos
        );
      }

      // --- Actualizar Estado ---
      setState(() {
        _noticias.addAll(nuevasNoticias);
        // Si la carga (inicial o adicional) trajo menos items que
        // el tamaño de página solicitado, asumimos que no hay más.
        // O si la carga adicional no trajo nada.
        if (nuevasNoticias.length < NoticiaConstantes.tamanoPagina || (nuevasNoticias.isEmpty && !isInitialLoad)) {
          _hasMore = false;
        }
        _error = null;
      });
    } catch (e) {
      print("Error al cargar noticias: $e");
      setState(() {
        // Solo mostrar error si es carga inicial o si ya teníamos noticias
        // para no sobreescribir la lista existente con un mensaje de error
        // si falla una carga adicional. Podrías mostrar un SnackBar en su lugar.
        if (isInitialLoad || _noticias.isEmpty) {
           _error = NoticiaConstantes.mensajeError;
        }
        _hasMore = false; // Detener intentos si hay error
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(NoticiaConstantes.tituloApp),
        backgroundColor: Colors.blue, // Puedes ajustar el color
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // --- Estado de Carga Inicial ---
    if (_isLoading && _noticias.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(NoticiaConstantes.mensajeCargando),
          ],
        ),
      );
    }

    // --- Estado de Error (sin datos previos) ---
    if (_error != null && _noticias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _cargarNoticias(isInitialLoad: true),
              child: const Text('Reintentar'),
            )
          ],
        ),
      );
    }

    // --- Estado Vacío (después de cargar, sin resultados) ---
    if (_noticias.isEmpty && !_isLoading && _error == null) {
      return const Center(
        child: Text(NoticiaConstantes.listaVacia),
      );
    }

    // --- Estado con Datos (Lista de Noticias) ---
    return RefreshIndicator(
      onRefresh: () => _cargarNoticias(isInitialLoad: true),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _noticias.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _noticias.length) {
            return _hasMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final noticia = _noticias[index];
          // Añadimos el Padding aquí para el espaciado
          return Padding(
            padding: const EdgeInsets.only(
              bottom: NoticiaConstantes.espaciadoAlto,
              left: 5.0, // Mantenemos el padding horizontal del Card original
              right: 5.0,
            ),
            child: buildNoticiaCard(context, noticia),
          );
        },
      ),
    );
  }
}
