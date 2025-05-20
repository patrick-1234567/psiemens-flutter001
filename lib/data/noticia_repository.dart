import 'package:psiemens/api/service/noticia_service.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/data/base_repository.dart';

class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _service = NoticiaService();
  
  @override
  NoticiaService get service => _service;

  /// Obtiene noticias con caché y manejo de errores
  Future<List<Noticia>> obtenerNoticias() async {
    return obtenerDatos(
      fetchFunction: () => _service.getNoticias(),
      cacheKey: 'noticias',
    );
  }

  /// Crea una nueva noticia
  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    // Validar campos requeridos
    validarNoVacio(titulo, 'título');
    validarNoVacio(descripcion, 'descripción');
    validarNoVacio(fuente, 'fuente');
    
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    
    await ejecutarOperacion(
      operation: () => _service.crearNoticia(noticia),
      errorMessage: 'Error inesperado al crear noticia.',
    );
  }

    Future<void> eliminarNoticia(String id) async {
    validarNoVacio(id, 'ID de la noticia');
    
    await ejecutarOperacion(
      operation: () => _service.eliminarNoticia(id),
      errorMessage: 'Error inesperado al eliminar noticia.',
    );
  }

  Future<void> actualizarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    // Validar campos requeridos
    validarNoVacio(id, 'ID de la noticia');
    validarNoVacio(titulo, 'título');
    validarNoVacio(descripcion, 'descripción');
    validarNoVacio(fuente, 'fuente');
    
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    
    await ejecutarOperacion(
      operation: () => _service.editarNoticia(id, noticia),
      errorMessage: 'Error inesperado al editar noticia.',
    );
  }
}