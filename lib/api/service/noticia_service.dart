
import 'package:psiemens/data/noticia_repository.dart'; // Ajusta la ruta si es necesario
import 'package:psiemens/domain/noticia.dart';       // Ajusta la ruta si es necesario
import 'dart:math'; // Para usar min

class NoticiaService {
  late final NoticiaRepository _noticiaRepository;

  // El servicio depende del repositorio, que se inyecta aquí.
  
  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    required int tamanoPagina,
  }) async {
    // 1. Validar parámetros de paginación
    if (numeroPagina < 1) {
      throw ArgumentError('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPagina <= 0) {
      throw ArgumentError('El tamaño de página debe ser mayor que 0.');
    }

    final todasLasNoticiasIniciales = await _noticiaRepository.getNoticias();

    // 3. Validar y filtrar las noticias individuales
    final noticiasValidas = _validarNoticias(todasLasNoticiasIniciales);

    // 4. Calcular los índices para la paginación sobre la lista filtrada
    final startIndex = (numeroPagina - 1) * tamanoPagina;

    if (startIndex >= noticiasValidas.length) {
      return []; // No hay noticias válidas para esta página
    }

    final endIndex = min(startIndex + tamanoPagina, noticiasValidas.length);

    // 5. Extraer y devolver la sublista de noticias válidas
    return noticiasValidas.sublist(startIndex, endIndex);
  }

  Future<List<Noticia>> cargarMasNoticias({
    required int cantidad,
    required int indiceActual, // El número de noticias ya mostradas
  }) async {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad de noticias a cargar debe ser mayor que 0.');
    }
    if (indiceActual < 0) {
       throw ArgumentError('El índice actual no puede ser negativo.');
    }

    // 2. Llamar al método del repositorio para obtener más noticias
    final nuevasNoticias = await _noticiaRepository.getNoticias();

    // 3. Validar y filtrar las noticias recién cargadas
    final noticiasValidas = _validarNoticias(nuevasNoticias);

    // 4. Devolver la lista de nuevas noticias válidas
    return noticiasValidas;
  }

    Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
  }) async {
    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
    };

    await _noticiaRepository.crearNoticia(noticia);
  }
  /// Función auxiliar para validar una lista de noticias.
  List<Noticia> _validarNoticias(List<Noticia> noticias) {
      final ahora = DateTime.now();
      return noticias.where((noticia) {
        final esTituloValido = noticia.titulo.trim().isNotEmpty;
        final esDescripcionValida = noticia.descripcion.trim().isNotEmpty;
        final esFuenteValida = noticia.fuente.trim().isNotEmpty;
        final esFechaValida = !noticia.publicadaEl.isAfter(ahora);

        return esTituloValido &&
               esDescripcionValida &&
               esFuenteValida &&
               esFechaValida;
      }).toList();
  }
}