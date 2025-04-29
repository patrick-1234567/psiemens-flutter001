import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:psiemens/views/login_screen.dart';
import 'package:psiemens/bloc/contador/contador_bloc.dart'; // Importa el BLoC del contador

Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContadorBloc(), // Proporciona el BLoC del contador
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        ),
        home: LoginScreen(), // Pantalla inicial
      ),
    );
  }
}