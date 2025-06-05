import 'package:flutter/material.dart';
import 'package:psiemens/helpers/dialog_helper.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:psiemens/views/acerca_de_screen.dart';
import 'package:psiemens/views/app_container.dart';
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
    return Container(      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.0, -1.8),
          end: const Alignment(0.0, 0.8),
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            Colors.white,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Patrick Flutter App',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.2, 0.2],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userEmail.isNotEmpty ? _userEmail : 'Usuario',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Bienvenido',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  leading: const Icon(Icons.apps, color: AppColors.primary),
                  title: const Text('Mi App', style: TextStyle(color: AppColors.primary)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ColorChangerScreen()),
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
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo de la empresa
                    Hero(
                      tag: 'app_logo',
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Image.asset(
                          'assets/images/sodep_logo.png',
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Mensaje de bienvenida
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '¡Bienvenido/a!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _userEmail,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}