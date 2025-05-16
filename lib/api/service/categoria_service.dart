import 'package:psiemens/api/service/base_service.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/categoria.dart';

/// Servicio para gestionar las operaciones relacionadas con categorías
/// Utiliza BaseService para las operaciones HTTP
class CategoriaService {
  final BaseService _baseService;
  
  /// Constructor que inicializa el BaseService
  CategoriaService({BaseService? baseService}) 
      : _baseService = baseService ?? BaseService();

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    // Utiliza el método get del BaseService
    final data = await _baseService.get('categorias');
    
    // Convierte los datos JSON a objetos Categoria
    return (data as List).map((json) => Categoria.fromJson(json)).toList();
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    // Utiliza el método post del BaseService
    await _baseService.post('categorias', data: categoria);
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    // Utiliza el método put del BaseService
    await _baseService.put('categorias', id, data: categoria);
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    // Utiliza el método delete del BaseService
    await _baseService.delete('categorias', id);
  }
}