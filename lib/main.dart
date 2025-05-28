import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:psiemens/bloc/auth/auth_bloc.dart';
import 'package:psiemens/bloc/comentarios/comentario_bloc.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/di/locator.dart';
import 'package:psiemens/bloc/contador/contador_bloc.dart';
import 'package:psiemens/bloc/connectivity/connectivity_bloc.dart';
import 'package:psiemens/components/connectivity_wrapper.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:psiemens/helpers/shared_preferences_service.dart';
import 'package:psiemens/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';
import 'package:psiemens/bloc/noticias/noticias_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initLocator(); // Carga el archivo .env
  // Inicializar el servicio/helper de SharedPreferences
  await SharedPreferencesService().init();

  // Eliminar cualquier token guardado para forzar el inicio de sesión
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(create: (context) => ContadorBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(create: (context) => ReporteBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        // Agregamos NoticiaBloc como un provider global para mantener el estado entre navegaciones
        BlocProvider<NoticiaBloc>(create: (context) => NoticiaBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          // Envolvemos con nuestro ConnectivityWrapper
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: LoginScreen(), // Pantalla inicial
      ),
    );
  }
}
