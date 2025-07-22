
import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<String?> login(String email, String password) async {
    try {
      await _authService.signInWithEmail(email, password);
      return null; // succès
    } catch (e) {
      return e.toString(); // message d'erreur
    }
  }
}