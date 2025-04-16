// lib/helpers/noticia_card_helper.dart
import 'package:flutter/material.dart';
import 'package:psiemens/domain/noticia.dart'; // Ajusta la ruta a tu clase Noticia

/// Construye un widget Card para mostrar la información de una Noticia con una imagen a la derecha.
///
/// [context]: El BuildContext actual.
/// [noticia]: La instancia de Noticia a mostrar.
Widget buildNoticiaCard(BuildContext context, Noticia noticia) {
  // Formateo manual de la fecha y hora
  final String dia = noticia.publicadaEl.day.toString().padLeft(2, '0');
  final String mes = noticia.publicadaEl.month.toString().padLeft(2, '0');
  final String anio = noticia.publicadaEl.year.toString();
  final String hora = noticia.publicadaEl.hour.toString().padLeft(2, '0');
  final String minuto = noticia.publicadaEl.minute.toString().padLeft(2, '0');

  final String fechaFormateada = '$dia/$mes/$anio $hora:$minuto';

  // URL de la imagen aleatoria
  final String imageUrl = 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}-${noticia.hashCode}';

  // Definir un ancho fijo para la imagen
  const double imageWidth = 100.0;
  // Definir una altura deseada (puede ajustarse según el diseño)
  const double cardHeight = 130.0; // Altura aproximada para el contenido
  // Definir el padding para la imagen
  const double imagePadding = 8.0;

  return Card(
    elevation: 2.0,
    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height: cardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- Contenido de Texto (a la izquierda) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Columna para Título y Descripción
                  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       // Título
                       Text(
                         noticia.titulo,
                         style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                         ),
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                       ),
                       const SizedBox(height: 4.0),
                       // Descripción
                       Text(
                         noticia.descripcion,
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(
                           fontSize: 13.0,
                           color: Colors.grey[700],
                         ),
                       ),
                     ],
                  ),
                  // Fila para Fuente y Fecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Fuente
                      Flexible(
                        child: Text(
                          noticia.fuente,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 11.0,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Fecha de Publicación
                      Text(
                        fechaFormateada,
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- Imagen Aleatoria (a la derecha con Padding) ---
          SizedBox( // Contenedor para la imagen con ancho fijo
            width: imageWidth,
            height: double.infinity, // Ocupar toda la altura disponible del Row
            // *** Añadir Padding aquí ***
            child: Padding(
              padding: const EdgeInsets.all(imagePadding), // Espaciado alrededor de la imagen
              child: ClipRRect( // Opcional: redondear esquinas de la imagen si se desea
                 borderRadius: BorderRadius.circular(8.0), // Ajusta el radio
                 child: Image.network(
                   imageUrl,
                   // Quitar width/height de aquí si ClipRRect los maneja
                   // width: imageWidth - (imagePadding * 2), // Ajustar si es necesario
                   // height: double.infinity,
                   fit: BoxFit.cover,
                   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                     if (loadingProgress == null) return child;
                     // El contenedor del loading ahora debe estar dentro del Padding/ClipRRect
                     return Container(
                       // width: imageWidth - (imagePadding * 2), // Ajustar si es necesario
                       color: Colors.grey[300],
                       child: Center(
                         child: CircularProgressIndicator(
                           strokeWidth: 2.0,
                           value: loadingProgress.expectedTotalBytes != null
                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                               : null,
                         ),
                       ),
                     );
                   },
                   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                     // El contenedor del error ahora debe estar dentro del Padding/ClipRRect
                     return Container(
                       // width: imageWidth - (imagePadding * 2), // Ajustar si es necesario
                       color: Colors.grey[300],
                       child: const Center(
                         child: Icon(Icons.broken_image, color: Colors.grey, size: 30),
                       ),
                     );
                   },
                 ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
