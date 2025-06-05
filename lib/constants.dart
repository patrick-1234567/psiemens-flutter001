import 'package:psiemens/core/api_config.dart';

class AppConstants {
  static const String errorUnauthorized = 'Se requiere autenticación';
  static const String tokenNoEncontrado = 'No se encontró el token de autenticación';
  static const String errorDeleteDefault = 'Error al eliminar el recurso';
  static const String errorUpdateDefault = 'Error al actualizar el recurso';
  static const String errorCreateDefault = 'Error al crear el recurso';  
  static const String errorGetDefault = 'Error al obtener el recurso';  
  static const String errorAccesoDenegado = 'Acceso denegado. Verifique su API key o IP autorizada';
  static const String limiteAlcanzado = 'Límite de peticiones alcanzado. Intente más tarde';
  static const String errorServidorMock = 'Error en la configuración del servidor mock';
  static const String errorConexionProxy = 'Error de conexión con el servidor proxy';
  static const String conexionInterrumpida = 'La conexión fue interrumpida';
  static const String errorRecuperarRecursos = 'Error al recuperar recursos del servidor';
  static const String errorCriticoServidor = 'Error crítico en el servidor';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const String notUser = 'No hay usuario autenticado';
  static const String usuarioDefault = 'Usuario anonimo';
  static const String errorCache = 'Error al actualizar caché local';
}

class GameConstants {
  static const String titleApp = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScore = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de Nuevo';
}

class FinanceConstants {
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 10;
}

class NoticiaConstantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String errorNotFound = 'Noticia no encontrada';
  static const String successUpdated = 'Noticia actualizada exitosamente';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized = 'No autorizado para acceder a noticia';
  static const String errorInvalidData = 'Datos inválidos en noticia';
  static const String errorServer = 'Error del servidor en noticia';
  static const String errorCreated = 'Error al crear la noticia';
  static const String errorUpdated = 'Error al editar la noticia';
  static const String errorDelete = 'Error al eliminar la noticia';
  static const String errorVerificarNoticiaExiste = 'Error al verificar si la noticia existe';
  static const String errorActualizarContadorReportes = 'Error al actualizar el contador de reportes';
  static const String errorActualizarContadorComentarios = 'Error al actualizar el contador de comentarios';
}

class ApiConstantes {
  static final String newsurl = ApiConfig.beeceptorBaseUrl;
  static const String categoriaEndpoint = '/categorias';
  static const String tareasCachePrefsEndpoint = '/tareasPreferencias';
  static const String tareasEndpoint = '/tareas';
  static const String noticiasEndpoint = '/noticias';
  static const String comentariosEndpoint = '/comentarios';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String reportesEndpoint = '/reportes';
  static const int timeoutSeconds = 10; 
  static const String errorTimeout = 'Tiempo de espera agotado'; 
}

class CategoriaConstantes {
  static const String mensajeError = 'Error al cargar categorias';
  static const String errorNocategoria = 'Categoría no encontrada';
  static const String errorUnauthorized = 'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
  static const String errorCreated = 'Error al crear la categoría';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String errorDelete = 'Error al eliminar la categoría';
  static const String defaultcategoriaId = 'Sin Categoria';
  static const String successCreated = 'Categoria creada exitosamente';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String listaVacia = 'No hay categorias disponibles';
  static const String errorAdd = 'Error al agregar categoría';
}

class ComentarioConstantes {
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
  static const String errorUnauthorized = 'No autorizado para acceder a comentario';
  static const String errorInvalidData = 'Datos inválidos en comentario';
  static const String errorNotFound = 'Comentario no encontrado';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  static const String errorCrear = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  static const String errorUnauthorized = 'No autorizado para acceder a reporte';
  static const String errorInvalidData = 'Datos inválidos en reporte';
  static const String errorServer = 'Error del servidor en reporte';
  static const String errorNotFound = 'Reporte no encontrado';
  static const String errorEliminarReportes = 'Error al eliminar los reportes de la noticia';
}

class ConectividadConstantes {
  static const String mensajeSinConexion = 'Por favor, verifica tu conexión a internet.';
}

class ValidacionConstantes {
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  static const String imagenUrl = 'URL de la imagen';
  static const String email = 'email del usuario';
  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
}

class TareasConstantes {
  static const String fechaLimite = 'Fecha límite: '; // Nueva constante
  static const String tareaEliminada = 'Tarea eliminada exitosamente'; // Nueva constante
  static const String tareaCreada = 'Tarea creada exitosamente'; // Nueva constante
  static const String tituloTarea = 'Título';
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String mensajeError = 'Error al obtener tareas';
  static const String errorCrear = 'Error al crear la tarea';
  static const String errorEliminar = 'Error al eliminar la tarea';
  static const String errorActualizar = 'Error al actualizar la tarea';
}

class PreferenciaConstantes{
  static const String errorServer = 'Error del servidor en preferencia';
  static const String errorUnauthorized = 'No autorizado para acceder a preferencia';
  static const String errorInvalidData = 'Datos inválidos en preferencia';
  static const String errorNotFound = 'Preferencia no encontrada';
  static const String mensajeError = 'Error al obtener categorías';
  static const String errorUpdated = 'Error al guardar preferencias';
  static const String errorCreated = 'Error al crear la preferencia';
  static const String errorInit = 'Error al inicializar preferencias';
}