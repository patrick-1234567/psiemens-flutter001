import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/noticias/noticias_bloc.dart';
import 'package:psiemens/bloc/noticias/noticias_event.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/views/comentarios/comentarios_screen.dart';
import 'package:psiemens/components/reporte_dialog.dart';
import 'package:psiemens/theme/theme.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit;
  final String categoriaNombre;
  final VoidCallback? onReport;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.gray04.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noticia.titulo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia.descripcion,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gray07,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia.fuente,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: AppColors.gray07.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatDate(noticia.publicadaEl),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.gray07,
                              ),
                            ),
                          ],
                        ),                      ),
                      const SizedBox(height: 16), // Espacio vertical adicional aumentado
                      // Image moved below text content
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          noticia.urlImagen.isNotEmpty
                              ? noticia.urlImagen
                              : 'https://via.placeholder.com/100',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              width: 100,
                              color: AppColors.gray04.withOpacity(0.3),
                              child: const Icon(
                                Icons.broken_image,
                                color: AppColors.gray07,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Footer with category and action buttons
                  Row(
                    children: [
                      // Category section
                      const SizedBox(width: 8),
                      Text(
                        categoriaNombre,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      // Action buttons
                      IconButton(
                        icon: const Icon(Icons.comment, color: AppColors.gray07),
                        tooltip: 'Ver comentarios',
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ComentariosScreen(
                                noticiaId: noticia.id!,
                                noticiaTitulo: noticia.titulo,
                              ),
                            ),
                          );
                          if (context.mounted) {
                            context.read<NoticiaBloc>().add(FetchNoticiasEvent());
                          }
                        },
                      ),                      if ((noticia.contadorComentarios ?? 0) > 0)
                        Text(
                          (noticia.contadorComentarios ?? 0) > 99 ? '99+' : '${noticia.contadorComentarios}',
                          style: const TextStyle(
                            color: AppColors.gray07,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.flag, color: AppColors.gray07),
                        tooltip: 'Reportar noticia',
                        onPressed: () {
                          if (onReport != null) {
                            onReport!();
                          } else {
                            ReporteDialog.mostrarDialogoReporte(
                              context: context,
                              noticia: noticia,
                            );
                          }
                        },
                      ),                      if (noticia.contadorReportes != null && noticia.contadorReportes! > 0)
                        Text(
                          noticia.contadorReportes! > 99 ? '99+' : '${noticia.contadorReportes}',
                          style: const TextStyle(
                            color: AppColors.gray07,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.gray07),
                        tooltip: 'Editar noticia',
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstants.formatoFecha).format(date);
  }
}
