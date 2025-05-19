import 'package:psiemens/bloc/comentarios/comentario_bloc.dart';
import 'package:psiemens/bloc/connectivity/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:psiemens/bloc/preferencia/preferencia_bloc.dart';
import 'package:psiemens/bloc/preferencia/preferencia_event.dart';
import 'package:psiemens/di/locator.dart';
import 'package:psiemens/bloc/auth/auth_bloc.dart'; // Importa el AuthBloc
import 'package:psiemens/helpers/secure_storage_service.dart'; // Importa el servicio de almacenamiento seguro
import 'package:watch_it/watch_it.dart'; // Importa watch_it para usar di
import 'package:psiemens/components/connectivity_wrapper.dart'; // Importa el wrapper de conectividad
import 'package:psiemens/views/login_screen.dart';
import 'package:psiemens/bloc/contador/contador_bloc.dart'; // Importa el BLoC del contador

Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: '.env');
  await initLocator();

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
        BlocProvider(create: (context) => ContadorBloc()),
        BlocProvider(
          create:
              (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(
          create: (context) => AuthBloc(),
        ), // Solo se inicializa el AuthBloc sin verificar autenticación
        BlocProvider(
          create: (context) => ConnectivityBloc(),
        ), // Bloc para gestionar la conectividad
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 254, 70, 85),
          ),
        ),
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: const LoginScreen(), // Pantalla inicial
      ),
    );
  }
}
