import 'package:flutter/material.dart';

/// Widget que envuelve la aplicación para gestionar la conectividad
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Simplemente retornamos el child, ya que ahora el handler maneja todo
    return child;
  }
}