import 'package:flutter/material.dart';
import 'package:psiemens/theme/theme.dart';

//Prompt 3
//Pregunta 1: se controla mediante el uso de setState
//Pregunta 2: hace que sus hijos se organicen en vertical  
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.bootcampTheme,
      home: const ColorChangerScreen(),
    );
  }
}

class ColorChangerScreen extends StatefulWidget {
  const ColorChangerScreen({super.key});

  @override
  State<ColorChangerScreen> createState() => _ColorChangerScreenState();
}

class _ColorChangerScreenState extends State<ColorChangerScreen> {
  final List<Color> _colors = [AppColors.primary, AppColors.secondary, Colors.green];
  Color _currentColor = Colors.blue; // Inicializa con el primer color

  void _changeColor() {
    setState(() {
      // Cambia al siguiente color en la lista
      int currentIndex = _colors.indexOf(_currentColor);
      _currentColor = _colors[(currentIndex + 1) % _colors.length];
    });
  }

  void _resetColor() {
    setState(() {
      _currentColor = Colors.white; // Cambia el color a blanco
    });
  }

  @override
  Widget build(BuildContext context) {    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Changer'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,              child: Text(
                'Cambio de color',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _changeColor,
                  child: const Text('Cambiar color'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _resetColor,
                  child: const Text('Resetear color'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}