import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String titleAppbar = 'Lista de Tareas';
  static const String emptyList = 'No hay tareas';
  static const String taskTypeLabel = "Tipo: ";
  static const String pasoTitulo = "Pasos para completar: ";
  static const String fechaLimite = 'Fecha límite: '; // Nueva constante
  static const String tareaEliminada = 'Tarea eliminada'; // Nueva constante
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
  static const int tamanoPagina = 7;
  static const double espaciadoAlto = 10;
  static const String apiKey = "bb6d2d708f0443ef8ed24679229a0e51";
  static const String query = "tecnologia"; // Término de búsqueda por defecto
}

class ApiConstantes{
  static String get crudCrudUrl => dotenv.env['CRUD_CRUD_URL'] ?? '';
  static String noticiasUrl = crudCrudUrl + "/noticias"; // URL de la API de noticias
  static String categoriaUrl = crudCrudUrl + "/categorias"; // URL de la API de categorías
  static String preferenciaUrl = crudCrudUrl + "/preferencias"; // URL de la API de preferencias
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
}
