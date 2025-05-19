import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/comentarios/comentario_bloc.dart';
import 'package:psiemens/bloc/comentarios/comentario_event.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';

class CommentInputForm extends StatelessWidget {
  final String noticiaId;
  final TextEditingController comentarioController;
  final String? respondingToId;
  final String? respondingToAutor;
  final VoidCallback onCancelarRespuesta;

  const CommentInputForm({
    super.key,
    required this.noticiaId,
    required this.comentarioController,
    required this.respondingToId,
    required this.respondingToAutor,
    required this.onCancelarRespuesta,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = const Color(0xFF90CAF9); // Azul claro
    final Color focusedBorderColor = const Color(0xFF1976D2);

    return Column(
      children: [
        const Divider(),
        if (respondingToId != null) _buildRespondingTo(),
        const SizedBox(height: 8),
        TextField(
          controller: comentarioController,
          decoration: InputDecoration(
            hintText: respondingToId == null 
                ? 'Escribe tu comentario' 
                : 'Escribe tu respuesta...',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor), // Borde azul claro normal
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor), // Borde azul claro cuando está habilitado
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor, width: 2), // Borde azul medio cuando tiene foco
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _handleSubmit(context),
          icon: const Icon(Icons.send),
          label: Text(respondingToId == null 
              ? 'Publicar comentario' 
              : 'Enviar respuesta'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.only(left: 15,right: 15,top: 10, bottom: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildRespondingTo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Respondiendo a $respondingToAutor',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onCancelarRespuesta,
            tooltip: 'Cancelar respuesta',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (comentarioController.text.trim().isEmpty) {
      SnackBarHelper.showSnackBar(
        context, 
        'El comentario no puede estar vacío', 
        statusCode: 400
      );
      return;
    }

    final fecha = DateTime.now().toIso8601String();
    final bloc = context.read<ComentarioBloc>();

    if (respondingToId == null) {
      bloc.add(AddComentario(
        noticiaId: noticiaId,
        texto: comentarioController.text,
        autor: 'Usuario anónimo',
        fecha: fecha,
      ));
    } else {
      bloc.add(AddSubcomentario(
        comentarioId: respondingToId!,
        noticiaId: noticiaId,
        texto: comentarioController.text,
        autor: 'Usuario anónimo',
      ));
    }

    bloc.add(GetNumeroComentarios(noticiaId: noticiaId));
    comentarioController.clear();
    onCancelarRespuesta();

    SnackBarHelper.showSnackBar(
      context, 
      'Comentario agregado con éxito', 
      statusCode: 200
    );
  }
}