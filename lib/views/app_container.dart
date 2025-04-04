import 'package:flutter/material.dart';
//Prompt 3
//Pregunta 1: se controla mediante el uso de setState
//Pregunta 2: hace que sus hijos se organicen en vertical  
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final List<Color> _colors = [Colors.blue, Colors.red, Colors.green];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Changer'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            color: _currentColor, // Usa la variable _currentColor
            alignment: Alignment.center,
            child: const Text(
              'Cambio de color',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _changeColor,
            child: const Text('Cambiar color'),
          ),
          ElevatedButton(
            onPressed: _resetColor,
            child: const Text('Resetear color'),
          ),
        ],
      ),
    );
  }
}