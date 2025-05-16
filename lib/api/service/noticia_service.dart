import 'package:psiemens/api/service/base_service.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/constants.dart';

/// Servicio para gestionar las operaciones relacionadas con noticias
/// Utiliza BaseService para las operaciones HTTP
class NoticiaService {
  final BaseService _baseService;
  
  /// Constructor que inicializa el BaseService
  NoticiaService({BaseService? baseService}) 
      : _baseService = baseService ?? BaseService();
  
  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> getNoticias() async {
    // Utiliza el método get del BaseService
    final data = await _baseService.get('noticias');
    
    // Convierte los datos JSON a objetos Noticia
    return (data as List).map((json) {
      return Noticia(
        id: json['_id'] ?? '',
        titulo: json['titulo'] ?? 'Sin título',
        descripcion: json['descripcion'] ?? 'Sin descripción',
        fuente: json['fuente'] ?? 'Fuente desconocida',
        publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
        imageUrl: json['urlImagen'] ?? '',
        categoriaId: json['categoriaId'] ?? CategoriaConstantes.defaultCategoriaId,
      );
    }).toList();
  }

  /// Edita una noticia existente en la API
  Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
    // Utiliza el método put del BaseService
    await _baseService.put('noticias', id, data: noticia);
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
    // Utiliza el método post del BaseService
    await _baseService.post('noticias', data: noticia);
  }

  /// Elimina una noticia de la API
  Future<void> eliminarNoticia(String id) async {
    // Utiliza el método delete del BaseService
    await _baseService.delete('noticias', id);
  }
}

  

