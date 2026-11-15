import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;

    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<String?> criarUsuario(String email, String password, String confrmpassord, String nome) async {

    if (password != confrmpassord) {
      return 'As senhas não coincidem.';
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Salva o nome digitado no perfil do Firebase Auth
      await userCredential.user?.updateDisplayName(nome);
      await userCredential.user?.reload();

      return 'Usuário criado com sucesso!';

    } catch (e) {

      if (e.hashCode == 170) {
        return('Email já está em uso.');
      } else if (e.hashCode == 171) {
        return('Senha muito fraca.');
      } else {
        return('Erro ao criar usuário: $e');
      }
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}