import 'package:psiemens/data/categoria_repository.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:watch_it/watch_it.dart';
 import 'package:psiemens/data/noticia_repository.dart'; 
 
 Future<void> initLocator() async {
   final sharedPreferences = await SharedPreferences.getInstance();
 
   di.registerSingleton<SharedPreferences>(sharedPreferences);
 
   di.registerSingleton<CategoriaRepository>(CategoriaRepository());
   di.registerSingleton<NoticiaRepository>(NoticiaRepository());
 
 }