import 'package:psiemens/core/api_config.dart';

class AppConstants {
  static const String titleAppbar = 'Lista de Tareas';
  static const String emptyList = 'No hay tareas';
  static const String taskTypeLabel = "Tipo: ";
  static const String pasoTitulo = "Pasos para completar: ";
  static const String fechaLimite = 'Fecha límite: '; // Nueva constante
  static const String tareaEliminada = 'Tarea eliminada'; // Nueva constante
  static const String agregarTarea = 'Agregar tarea'; 
  static const String tituloTarea = 'Título';
  static const String editarTarea = 'Editar Tarea';
  static const String descripcionTarea = 'Descripcion';
  static const String fechaTarea = 'Fecha';
  static const String cancelar = 'Cancelar';
  static const String guardar = 'Guardar';
  static const String camposVacios = 'Por favor, completa todos los campos obligatorios.';
  static const String tipoTarea = 'Tipo';
  static const int timeoutSeconds = 10;
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String errorServer = 'Error del servidor';//
  static const String errorUnauthorized = 'Se requiere autenticación';//
  static const String errorNoInternet = 'Sin conexión a Internet';//
  static const String errorInvalidData = 'Datos inválidos';//
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
  static const String mensajeError = 'Error al obtener tareas';
  static const String errorCrear = 'Error al crear la tarea';
  static const String errorEliminar = 'Error al eliminar la tarea';
  static const String errorActualizar = 'Error al actualizar la tarea';
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
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const String publicadaEl = 'Publicado el';
  static const int tamanoPagina = 7;
  static const double espaciadoAlto = 10;
  static const String defaultCategoriaId = 'default';
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
  static const String errorFilter = "Error al filtrar noticias";
}

class ApiConstantes {
  static final String newsurl = ApiConfig.beeceptorBaseUrl;
  static const String categoriaEndpoint = '/categorias';
  static const String tareasCachePrefsEndpoint = '/tareasPreferencias';
  static const String tareasEndpoint = '/tareas';
  static const int timeoutSeconds = 10; 
  static const String errorTimeout = 'Tiempo de espera agotado'; 
  static const String errorNoCategory = 'Categoría no encontrada'; 
  static const String defaultcategoriaId = 'sin_categoria'; 
  static const String listasVacia = 'No hay categorias disponibles';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String categorysuccessCreated = 'Categoría creada con éxito';
  static const String categorysuccessUpdated = 'Categoría actualizada con éxito';
  static const String categorysuccessDeleted = 'Categoría eliminada con éxito';
  static const String newssuccessCreated = 'Noticia creada con éxito';
  static const String newssuccessUpdated = 'Noticia actualizada con éxito';
  static const String newssuccessDeleted = 'Noticia eliminada con éxito';
  static const String errorUnauthorized = 'No autorizado'; 
  static const String errorNotFound = 'Noticias no encontradas';
  static const String errorServer = 'Error del servidor';
  static const String errorNoInternet = 'Por favor, verifica tu conexión a internet.';
  static const String noticiasEndpoint = '/noticias';
  static const String comentariosEndpoint = '/comentarios';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String reportesEndpoint = '/reportes';
}

class ErrorConstantes {
  static const String errorServer = 'Error del servidor';
  static const String errorNotFound = 'Noticias no encontradas.';
  static const String errorUnauthorized = 'No autorizado';
}

class CategoriaConstantes {
  static const int timeoutSeconds = 10; // Tiempo máximo de espera en segundos
  static const String errorTimeout = 'Tiempo de espera agotado'; // Mensaje para errores de timeout
  static const String errorNoCategoria = 'Categoría no encontrada'; // Mensaje para errores de categorías
  static const String defaultCategoriaId = 'sin_categoria'; // ID por defecto para noticias sin categoría
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
}

class ComentarioConstantes {
  static const String mensajeCargando = 'Cargando comentarios...';
  static const String listaVacia = 'No hay comentarios disponibles';
  static const String errorNoComentario = 'Comentario no encontrado';
  static const String successCreated = 'Comentario agregado exitosamente';
  static const String successReaction = 'Reacción registrada exitosamente';
  static const String successSubcomentario = 'Subcomentario agregado exitosamente';
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  static const String noticiaNoExiste = 'La noticia reportada no existe';
  static const String errorCrearReporte = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  static const String listaVacia = 'No hay reportes disponibles';
  static const String mensajeCargando = 'Cargando reportes...';
}

class ConectividadConstantes {
  static const String mensajeSinConexion = 'Por favor, verifica tu conexión a internet.';
  static const String mensajeReconectando = 'Intentando reconectar...';
  static const String mensajeReconectado = 'Conexión restablecida';
  static const int intentosReconexion = 3;
  static const int tiempoEsperaReconexion = 5000; // milisegundos
  static const String tituloModoOffline = 'Modo sin conexión';
  static const String mensajeDinosaurio = 'Oh no! Parece que estás sin conexión';
}

class ValidacionConstantes {
  // Mensajes genéricos
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  static const String imagenUrl = 'URL de la imagen';

  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
}

class TareasConstantes {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String tipoTarea = 'Tipo: ';
  static const String taskTypeNormal = 'normal';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  static const String tareaEliminada = 'Tarea eliminada';
  static const int limitePasos = 2;
  static const int limiteTareas = 10;
  static const String mensajeError = 'Error al obtener tareas';
  static const String errorEliminar = 'Error al eliminar la tarea';
  static const String errorActualizar = 'Error al actualizar la tarea';
  static const String errorCrear = 'Error al crear la tarea';

}