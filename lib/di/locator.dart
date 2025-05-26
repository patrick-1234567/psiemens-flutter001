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
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());  
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
  di.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  di.registerSingleton<TareaService>(TareaService());
  di.registerSingleton<TareasRepository>(TareasRepository());
}