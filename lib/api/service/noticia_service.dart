import 'package:psiemens/data/noticia_repository.dart'; // Ajusta la ruta si es necesario
import 'package:psiemens/domain/noticia.dart';       // Ajusta la ruta si es necesario
import 'dart:math'; // Para usar min

class NoticiaService {
  final NoticiaRepository _noticiaRepository;

  // El servicio depende del repositorio, que se inyecta aquí.
  NoticiaService(this._noticiaRepository);

  /// Obtiene la carga inicial de noticias (primera página).
  ///
  /// Valida que los parámetros de paginación sean correctos y que las noticias
  /// recuperadas cumplan con los criterios (campos no vacíos, fecha no futura).
  ///
  /// [numeroPagina]: El número de página a obtener (normalmente 1 para la inicial).
  /// [tamanoPagina]: La cantidad de noticias por página (> 0).
  /// Devuelve un Future que se completa con la lista de noticias válidas de esa página.
  /// Lanza [ArgumentError] si los parámetros de paginación son inválidos.
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

    // 2. Obtener todas las noticias iniciales del repositorio
    // En un escenario real, getNoticias podría aceptar parámetros de paginación
    // o podrías tener un método específico getInitialNoticias.
    // Por ahora, obtenemos todas y filtramos/paginamos aquí.
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

  /// Carga noticias adicionales desde el repositorio usando loadMoreNoticias.
  ///
  /// Valida que las noticias recuperadas cumplan con los criterios.
  ///
  /// [cantidad]: El número de noticias a cargar (> 0).
  /// [indiceActual]: El número total de noticias ya cargadas (para el startIndex).
  /// Devuelve un Future que se completa con la lista de nuevas noticias válidas.
  /// Lanza [ArgumentError] si la cantidad es inválida.
  Future<List<Noticia>> cargarMasNoticias({
    required int cantidad,
    required int indiceActual, // El número de noticias ya mostradas
  }) async {
    // 1. Validar parámetro de cantidad
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad de noticias a cargar debe ser mayor que 0.');
    }
    if (indiceActual < 0) {
      // Aunque poco probable, es bueno validar
       throw ArgumentError('El índice actual no puede ser negativo.');
    }

    // 2. Llamar al método del repositorio para obtener más noticias
    final nuevasNoticias = await _noticiaRepository.loadMoreNoticias(
      cantidad,
      indiceActual, // Pasamos el número de noticias actuales como startIndex
    );

    // 3. Validar y filtrar las noticias recién cargadas
    final noticiasValidas = _validarNoticias(nuevasNoticias);

    // 4. Devolver la lista de nuevas noticias válidas
    return noticiasValidas;
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