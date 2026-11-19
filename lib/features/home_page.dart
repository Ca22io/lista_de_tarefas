import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Auth/login_page.dart';
import 'calendar_page.dart';

import '../service/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../service/FirestoreService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  bool _mostrarPendentes = true;
  DateTime _dataSelecionada = DateTime.now().toLocal();

  final TextEditingController _novaTarefaController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _novaTarefaController.dispose();
    super.dispose();
  }

  void _abrirDialogAdicionar(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bookmark_border, color: Colors.white70),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicionar tarefa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF86FA43), Colors.cyanAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: TextField(
                          controller: _novaTarefaController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Ex: Estudar para a prova',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            _novaTarefaController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF86FA43), Colors.cyanAccent],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              if (_novaTarefaController.text.isNotEmpty) {
                                final texto = _novaTarefaController.text.trim();
                                _firestoreService.adicionarTarefa(
                                  titulo: texto,
                                  data: _formatarData(_dataSelecionada),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _abrirCalendario() async {
    final data = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarPage(dataInicial: _dataSelecionada),
      ),
    );
    if (data != null && mounted) {
      setState(() => _dataSelecionada = data);
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')} / '
        '${data.month.toString().padLeft(2, '0')} / ${data.year}';
  }

  void _deslogar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Captura o usuário logado e define um fallback caso venha nulo/vazio
    final user = FirebaseAuth.instance.currentUser;
    final String nomeUsuario = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : 'Usuário';
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/espaco.jpg', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  _buildGlassContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bom dia,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Gradiente aplicado no Nome do Usuário
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF86FA43), Colors.cyanAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                nomeUsuario,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _abrirCalendario,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                // Gradiente aplicado no ícone e texto da Data
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF86FA43),
                                          Colors.cyanAccent,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatarData(_dataSelecionada),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: IconButton(
                                tooltip: 'Sair',
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await _authService.logout();
                                  _deslogar();
                                },
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white70,
                                  size: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildGlassContainer(
                    padding: const EdgeInsets.all(0),
                    borderRadius: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _mostrarPendentes = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                // Fundo destacado se estiver selecionado
                                color: _mostrarPendentes
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: _mostrarPendentes
                                        ? const Color(0xFF86FA43)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Pendentes',
                                style: TextStyle(
                                  color: _mostrarPendentes
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _mostrarPendentes = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                // Fundo destacado se estiver selecionado
                                color: !_mostrarPendentes
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(
                                    color: !_mostrarPendentes
                                        ? const Color(0xFF86FA43)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Concluídos',
                                style: TextStyle(
                                  color: !_mostrarPendentes
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestoreService.getTarefasStream(
                        concluida: !_mostrarPendentes,
                        data: _formatarData(_dataSelecionada),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Color(0xFF86FA43)),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Erro ao carregar tarefas.',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return Center(
                            child: Text(
                              _mostrarPendentes
                                  ? 'Nenhuma tarefa pendente para esta data.'
                                  : 'Nenhuma tarefa concluída para esta data.',
                              style: const TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final String titulo = data['titulo'] ?? '';
                            final bool concluida = data['concluida'] ?? false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildGlassContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                borderRadius: 12,
                                child: Row(
                                  children: [
                                    // Checkbox funcional para mover entre Pendentes e Concluídos
                                    GestureDetector(
                                      onTap: () => _firestoreService.alternarStatusTarefa(docId: doc.id, 
                                      statusAtual: concluida, 
                                      data: _formatarData(_dataSelecionada)),
                                      child: Icon(
                                        concluida ? Icons.check_box : Icons.check_box_outline_blank,
                                        color: concluida ? const Color(0xFF86FA43) : Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        titulo,
                                        style: TextStyle(
                                          color: concluida ? Colors.white54 : Colors.white,
                                          fontSize: 15,
                                          decoration: concluida ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                    ),
                                    // Botão de lixeira conectado ao Firestore
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                      onPressed: () => _firestoreService.excluirTarefa(
                                        docId: doc.id,
                                        data: _formatarData(_dataSelecionada),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF86FA43), Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF86FA43).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _abrirDialogAdicionar(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.black87, size: 32),
        ),
      ),
    );
  }
}
