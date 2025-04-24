import 'package:flutter/material.dart';
//backend
import 'package:psiemens/api/service/noticia_service.dart';
import 'package:psiemens/components/crear_noticia_screen.dart';
import 'package:psiemens/domain/noticia.dart';
//component
import 'package:psiemens/constants.dart';

import 'package:psiemens/helpers/noticia_card_helper.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> noticiasList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        _loadNoticias();
      }
    });
  }

  Future<void> _loadNoticias() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newNoticias = await _noticiaService.getPaginatedNoticia(
        pageNumber: currentPage,
        pageSize: NoticiaConstantes.tamanoPagina,
      );

      setState(() {
        noticiasList.addAll(newNoticias);
        isLoading = false;
        hasMore = newNoticias.length == NoticiaConstantes.tamanoPagina;
        if (hasMore) currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text(NoticiaConstantes.mensajeError)));
    }
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo gris claro
      appBar: AppBar(title: const Text(NoticiaConstantes.tituloApp)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CrearNoticiaPopup.mostrarPopup(context);
        },
        tooltip: 'Agregar Noticia',
        child: const Icon(Icons.add),
      ),
      body:
          noticiasList.isEmpty && isLoading
              ? const Center(child: Text(NoticiaConstantes.mensajeCargando))
              : ListView.builder(
                controller: _scrollController,
                itemCount: noticiasList.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < noticiasList.length) {
                    final noticia = noticiasList[index];

                    return Column(
                      children: [
                        // Tarjeta de noticia
                        NoticiaCardHelper.buildNoticiaCard(
                          noticia, // URL de la imagen
                        ),

                        // Línea divisoria
                        Divider(
                          color: Colors.grey[500], // Color negro
                          thickness: 0.5, // Grosor de la línea
                          height: 1, // Espaciado vertical
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
    );
  }
}
