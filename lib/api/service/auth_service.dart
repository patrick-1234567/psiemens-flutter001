import 'dart:async';

class AuthService {
  Future<bool> login(String username, String password) async {
    // Verifica que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      print('Error: Las credenciales no pueden estar vacías.');
      return false;
    }

    // Simula un retraso como si estuviera llamando a un backend
    await Future.delayed(const Duration(seconds: 2));

    // Imprime las credenciales en la consola
    print('Username: $username');
    print('Password: $password');

    // Retorna true para simular un login exitoso
    return true;
  }
}