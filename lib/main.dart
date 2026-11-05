import 'package:flutter/material.dart';
// Ajuste o caminho do import se as pastas estiverem com letras maiúsculas/minúsculas diferentes
import 'features/auth/login_page.dart'; 

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false, // Remove a faixa vermelha de "DEBUG" no canto da tela
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, 
      ),
      home: const LoginPage(),
    );
  }
}