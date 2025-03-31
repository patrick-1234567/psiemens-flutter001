import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Center(
        child: const Text(
          '¡Bienvenido! El login fue exitoso.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
