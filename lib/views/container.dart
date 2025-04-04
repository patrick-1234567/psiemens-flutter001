import 'package:flutter/material.dart';
//Prompt 1 
//Pregunta 1: el container es un contenedor visual que organiza y estiliza su contenido.
//Pregunta 2: los elementos se organizan verticalmente en una columna

//Prompt 2
//Pregunta 1: utilizamos setStatepara indicar que el estado del widget ha cambiado y que debe ser reconstruido.
//Pregunta 2: si no usamos setState se incrementara el valor de counter pero no se actualizara la interfaz


class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  int _counter = 0; // Variable para el contador

  void _incrementCounter() {
    setState(() {
      _counter++; // Incrementa el contador
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.red,
            child: const Text(
              'Hola, Flutter',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Text(
            'Veces presionado: $_counter', // Muestra el valor del contador
            style: const TextStyle(
              fontSize: 20,
              color: Colors.blue,
              ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _incrementCounter, // Llama a la función para incrementar
            child: const Text('Presionar'),
          ),
        ],
      ),
    );
  }
}
