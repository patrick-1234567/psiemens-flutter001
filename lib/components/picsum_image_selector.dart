import 'package:flutter/material.dart';

class PicsumImageSelector extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;

  const PicsumImageSelector({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<PicsumImageSelector> createState() => _PicsumImageSelectorState();
}

class _PicsumImageSelectorState extends State<PicsumImageSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchImages() async {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa una palabra para buscar';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Utilizar la API de Picsum para obtener imágenes
      // Como Picsum no tiene búsqueda por palabra clave, simularemos una búsqueda
      // usando la palabra como semilla para generar imágenes aleatorias pero consistentes
      final seed = searchTerm.hashCode.abs(); // Usar hashCode como semilla
      final urls = <String>[];

      // Generar 9 imágenes basadas en la semilla
      for (var i = 0; i < 9; i++) {
        final width = 300;
        final height = 200;
        final imageId = (seed + i) % 1000 + 1; // ID entre 1 y 1000
        urls.add('https://picsum.photos/id/$imageId/$width/$height');
      }

      setState(() {
        _imageUrls = urls;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = 'Error al generar imágenes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seleccionar Imágenes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.primary),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Cerrar',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Palabra aleatoria',
                    hintText: 'Escribe cualquier palabra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (_) => _searchImages(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searchImages,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Mostrar'),
              ),
            ],
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_imageUrls.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = _imageUrls[index];
                  return GestureDetector(
                    onTap: () {
                      widget.onImageSelected(imageUrl);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(127)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: theme.colorScheme.error,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(179),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_search,
                    size: 48,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ingresa cualquier palabra para mostrar imágenes aleatorias',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nota: Las imágenes no están relacionadas con la palabra ingresada',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          // Botón de Cancelar al final
          if (!_isLoading && _imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}