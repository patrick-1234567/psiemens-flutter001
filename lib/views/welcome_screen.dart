import 'package:flutter/material.dart';
import 'package:psiemens/helpers/dialog_helper.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:psiemens/views/acerca_de_screen.dart';
import 'package:psiemens/views/categoria_screen.dart';
import 'package:psiemens/views/contador_screen.dart';
import 'package:psiemens/views/login_screen.dart';
import 'package:psiemens/views/task_screen.dart';
import 'package:psiemens/views/start_screen.dart';
import 'package:psiemens/views/quote_screen.dart';
import 'package:psiemens/views/noticia_screen.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _verificarAutenticacionYCargarEmail();
  }

  Future<void> _verificarAutenticacionYCargarEmail() async {
    final SecureStorageService secureStorage = di<SecureStorageService>();

    // Verificar si hay un token válido
    final token = await secureStorage.getJwt();

    // Si no hay token, redireccionar a la pantalla de login
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    // Si hay token, cargar el email del usuario
    final email = await secureStorage.getUserEmail() ?? 'Usuario';
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrick Flutter App'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userEmail.isNotEmpty ? _userEmail : 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list, color: AppColors.primary),
              title: const Text('Lista de Tareas', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TareaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.countertops, color: AppColors.primary),
              title: const Text('Contador', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContadorScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: AppColors.primary),
              title: const Text('Juego de Preguntas', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money, color: AppColors.primary),
              title: const Text('Cotizaciones', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuoteScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper, color: AppColors.primary),
              title: const Text('Noticias', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoticiaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: AppColors.primary),
              title: const Text('Categorias', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.primary),
              title: const Text('Acerca de', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AcercaDeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.primary)),
              onTap: () {
                DialogHelper.mostrarDialogoCerrarSesion(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido/a $_userEmail! El login fue exitoso.',
              style: const TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}