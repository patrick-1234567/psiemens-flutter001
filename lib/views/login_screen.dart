import 'package:flutter/material.dart';
import 'package:psiemens/views/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? usernameError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de usuario
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  errorText: usernameError, // Muestra el mensaje de error
                ),
              ),
              const SizedBox(height: 16),

              // Campo de contraseña
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  errorText: passwordError, // Muestra el mensaje de error
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    usernameError = usernameController.text.isEmpty
                        ? 'Por favor, ingresa tu usuario'
                        : null;
                    passwordError = passwordController.text.isEmpty
                        ? 'Por favor, ingresa tu contraseña'
                        : null;

                    if (usernameError == null && passwordError == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, // Cambia el color del texto
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Ajusta el tamaño del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}