import 'dart:async'; // Necesario para Future y Duration
import 'package:psiemens/domain/noticia.dart'; // Asegúrate que la ruta sea correcta
import 'dart:math';
class NoticiaRepository {
  // Lista privada de noticias iniciales (ahora con 15 noticias)
  final List<Noticia> _noticias = [
    Noticia(
      titulo: "Avance Tecnológico Revoluciona la Industria",
      descripcion: "Una nueva tecnología promete cambiar radicalmente cómo operan las fábricas.",
      fuente: "Tech News Daily",
      publicadaEl: DateTime(2023, 10, 26, 9, 0, 0),
    ),
    Noticia(
      titulo: "Descubrimiento Científico Abre Nuevas Puertas",
      descripcion: "Investigadores anuncian un hallazgo que podría llevar a tratamientos médicos innovadores.",
      fuente: "Science Journal",
      publicadaEl: DateTime(2023, 10, 25, 14, 30, 0),
    ),
    Noticia(
      titulo: "Mercado Bursátil Muestra Signos de Recuperación",
      descripcion: "Los índices globales suben tras semanas de incertidumbre económica.",
      fuente: "Financial Times",
      publicadaEl: DateTime(2023, 10, 26, 10, 15, 0),
    ),
    Noticia(
      titulo: "Evento Cultural Atrae Multitudes",
      descripcion: "El festival anual de arte y música superó las expectativas de asistencia.",
      fuente: "City Gazette",
      publicadaEl: DateTime(2023, 10, 24, 18, 0, 0),
    ),
    Noticia(
      titulo: "Nuevas Regulaciones Ambientales Anunciadas",
      descripcion: "El gobierno implementa medidas más estrictas para la protección del medio ambiente.",
      fuente: "Gov Today",
      publicadaEl: DateTime(2023, 10, 23, 11, 0, 0),
    ),
    Noticia(
      titulo: "Lanzamiento Exitoso de Misión Espacial",
      descripcion: "La agencia espacial confirma que la sonda ha alcanzado su órbita objetivo.",
      fuente: "Space Agency News",
      publicadaEl: DateTime(2023, 10, 22, 22, 45, 0),
    ),
    Noticia(
      titulo: "Innovación en Energías Renovables",
      descripcion: "Una startup presenta una solución eficiente para el almacenamiento de energía solar.",
      fuente: "Clean Energy Weekly",
      publicadaEl: DateTime(2023, 10, 21, 16, 20, 0),
    ),
    Noticia(
      titulo: "Debate sobre Inteligencia Artificial en la Educación",
      descripcion: "Expertos discuten el impacto y las implicaciones éticas de la IA en las aulas.",
      fuente: "Education Insights",
      publicadaEl: DateTime(2023, 10, 20, 13, 0, 0),
    ),
    Noticia(
      titulo: "Tendencias de Viaje para la Próxima Temporada",
      descripcion: "Las agencias de viajes reportan un aumento en las reservas para destinos exóticos.",
      fuente: "Travel Magazine",
      publicadaEl: DateTime(2023, 10, 19, 10, 55, 0),
    ),
    Noticia(
      titulo: "Campeonato Deportivo Define a sus Finalistas",
      descripcion: "Tras emocionantes semifinales, los equipos finalistas se preparan para el gran encuentro.",
      fuente: "Sports Report",
      publicadaEl: DateTime(2023, 10, 25, 21, 30, 0),
    ),
    // --- 5 Noticias Adicionales ---
    Noticia(
      titulo: "Nuevo Acuerdo Comercial Impulsa Exportaciones",
      descripcion: "Se firma un tratado bilateral que facilitará el comercio entre dos naciones clave.",
      fuente: "Global Trade Monitor",
      publicadaEl: DateTime(2023, 10, 27, 8, 0, 0),
    ),
    Noticia(
      titulo: "Avances en la Investigación del Cáncer",
      descripcion: "Un estudio reciente muestra resultados prometedores para una nueva terapia dirigida.",
      fuente: "Medical Research Today",
      publicadaEl: DateTime(2023, 10, 26, 15, 45, 0),
    ),
    Noticia(
      titulo: "La Realidad Virtual Transforma el Entretenimiento",
      descripcion: "Nuevos dispositivos y plataformas de VR ofrecen experiencias inmersivas sin precedentes.",
      fuente: "Future Tech",
      publicadaEl: DateTime(2023, 10, 27, 11, 20, 0),
    ),
    Noticia(
      titulo: "Crisis Hídrica Afecta a Región Agrícola",
      descripcion: "La escasez de agua pone en riesgo las cosechas y la economía local.",
      fuente: "Environment News",
      publicadaEl: DateTime(2023, 10, 24, 9, 10, 0),
    ),
    Noticia(
      titulo: "Estreno Cinematográfico Rompe Récords de Taquilla",
      descripcion: "La última superproducción de Hollywood domina la taquilla mundial en su primer fin de semana.",
      fuente: "Entertainment Weekly",
      publicadaEl: DateTime(2023, 10, 23, 19, 0, 0),
    ),
  ];


  final _random = Random();
  /// Obtiene la lista de noticias simulando una llamada a API con retraso
  /// Devuelve un Future que se completa con la lista de noticias después de 2 segundos.
  Future<List<Noticia>> getNoticias() async {
    // Simula el tiempo de espera de una respuesta de red/API
    await Future.delayed(const Duration(seconds: 2));

    // Devuelve una copia inmutable de la lista después del retraso
    return List<Noticia>.unmodifiable(_noticias);
  }


  Future<List<Noticia>> loadMoreNoticias(int count, int startIndex) async {
    // Simula el tiempo de espera de una respuesta de red/API
    await Future.delayed(const Duration(milliseconds: 1500));

    // Lista de fuentes de ejemplo para variedad
    const fuentesEjemplo = [
      "Noticias Ficticias", "El Correo Digital", "Tech Avanzada",
      "Ciencia Hoy", "Eco Planeta", "Mundo Deportivo", "Cultura Global"
    ];

    // Genera 'count' noticias nuevas
    return List.generate(count, (index) {
      final noticiaIndex = startIndex + index;
      final fuenteAleatoria = fuentesEjemplo[_random.nextInt(fuentesEjemplo.length)];
      // Genera una fecha aleatoria en los últimos 3 días
      final fechaAleatoria = DateTime.now().subtract(Duration(
          days: _random.nextInt(3),
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60)
      ));

      return Noticia(
        titulo: 'Noticia Adicional ${noticiaIndex + 1}',
        descripcion: 'Esta es la descripción detallada para la noticia adicional número ${noticiaIndex + 1}. Contiene texto de relleno para simular contenido real.',
        fuente: fuenteAleatoria,
        publicadaEl: fechaAleatoria,
      );
    });
  }
  // Otros métodos futuros (getNoticiaById, addNoticia, etc.) también
  // deberían probablemente devolver Futures si simulan operaciones asíncronas.
}