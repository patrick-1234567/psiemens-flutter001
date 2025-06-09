import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/auth/auth_bloc.dart';
import 'package:psiemens/bloc/auth/auth_event.dart';
import 'package:psiemens/bloc/auth/auth_state.dart';
import 'package:psiemens/bloc/noticias/noticias_bloc.dart';
import 'package:psiemens/bloc/noticias/noticias_event.dart';
import 'package:psiemens/components/snackbar_component.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:psiemens/views/welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Mostrar indicador de carga
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is AuthAuthenticated) {
            // Cerrar diálogo de carga si está abierto
            Navigator.of(
              context,
              rootNavigator: true,
            ).popUntil((route) => route.isFirst);

            // Cargar noticias para el nuevo usuario
            context.read<NoticiaBloc>().add(FetchNoticiasEvent());

            // Navegar a la pantalla principal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          } else if (state is AuthFailure) {
            // Cerrar diálogo de carga si está abierto
            Navigator.of(
              context,
              rootNavigator: true,
            ).popUntil((route) => route.isFirst);

            // Mostrar error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarComponent.crear(
                mensaje: state.error.message,
                color: Colors.red,
                duracion: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          // Logo
                          Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              'assets/images/sodep_logo.png',
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Título
                          const Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Inicia sesión para continuar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Campo de usuario
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                hintText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.person_outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'El correo es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Campo de contraseña
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'La contraseña es obligatoria';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Botón de inicio de sesión
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final username = usernameController.text.trim();
                                  final password = passwordController.text.trim();
                                  context.read<AuthBloc>().add(
                                    AuthLoginRequested(
                                      email: username,
                                      password: password,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 145),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
