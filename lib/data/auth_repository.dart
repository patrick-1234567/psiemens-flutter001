import 'package:flutter/material.dart';
import 'package:psiemens/api/service/auth_service.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:psiemens/domain/login_response.dart';
import 'package:psiemens/domain/login_request.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/exceptions/api_exception.dart';

class AuthRepository extends BaseRepository<LoginResponse> {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();
  
  @override
  AuthService get service => _authService;

  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      validarNoVacio(email, 'correo electrónico');
      validarNoVacio(password, 'contraseña');
      
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );
      
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await ejecutarOperacion(
      operation: () async {
        await _secureStorage.clearJwt();
        await _secureStorage.clearUserEmail();
        limpiarCache(); // Limpiar caché al cerrar sesión
      },
      errorMessage: 'Error al cerrar sesión.',
    );
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    // Siempre retorna false para forzar la pantalla de login
    return false;
  }
  
  // Get current auth token
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.getJwt();
    } catch (e) {
      debugPrint('Error al obtener token de autenticación: $e');
      throw ApiException('Error al obtener token de autenticación');
    }
  }
}