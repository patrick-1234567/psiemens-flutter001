import 'package:psiemens/api/service/comentarios_service.dart';
import 'package:psiemens/api/service/noticia_service.dart';
import 'package:psiemens/api/service/task_service.dart';
import 'package:psiemens/bloc/reportes/reportes_bloc.dart';
import 'package:psiemens/data/auth_repository.dart';
import 'package:psiemens/data/categoria_repository.dart';
import 'package:psiemens/data/comentario_repository.dart';
import 'package:psiemens/data/noticia_repository.dart';
import 'package:psiemens/data/preferencia_repository.dart';
import 'package:psiemens/data/reporte_repository.dart';
import 'package:psiemens/data/task_repository.dart';
import 'package:psiemens/helpers/connectivity_service.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:psiemens/helpers/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // Registrar primero los servicios básicos
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  
  // Servicios de API
  di.registerLazySingleton<TareaService>(() => TareaService());
  di.registerLazySingleton<ComentarioService>(() => ComentarioService());
  di.registerLazySingleton<NoticiaService>(() => NoticiaService());
  
  // Repositorios
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TareasRepository>(() => TareasRepository());


  
  // BLoCs
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}