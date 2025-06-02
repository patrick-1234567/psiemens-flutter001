import 'package:psiemens/api/service/auth_service.dart';
import 'package:psiemens/data/preferencia_repository.dart';
import 'package:psiemens/data/task_repository.dart';
import 'package:psiemens/domain/login_request.dart';
import 'package:psiemens/domain/login_response.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final _secureStorage = di<SecureStorageService>();
  final _tareaRepository = di<TareasRepository>();
  final preferenciaRepository = di<PreferenciaRepository>();
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }
      preferenciaRepository.invalidarCache();
      final loginRequest = LoginRequest(username: email, password: password);
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      await preferenciaRepository.cargarDatos();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    preferenciaRepository.invalidarCache();
    _tareaRepository.limpiarCache();
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}
