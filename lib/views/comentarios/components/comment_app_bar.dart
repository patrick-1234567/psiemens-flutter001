import 'package:flutter/material.dart';
import 'package:psiemens/theme/theme.dart';

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool ordenAscendente;
  final Function(bool) onOrdenChanged;
  final String? titulo;

  const CommentAppBar({
    super.key,
    required this.ordenAscendente,
    required this.onOrdenChanged,
    this.titulo,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(
        titulo != null ? 'Comentarios: $titulo' : 'Comentarios',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Tooltip(
          message: ordenAscendente 
              ? 'Ordenar por más recientes' 
              : 'Ordenar por más antiguos',
          child: IconButton(
            onPressed: () => onOrdenChanged(!ordenAscendente),
            icon: Icon(
              ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}