import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Converte "18 / 11 / 2026" para "18-11-2026" (evita que o Firestore quebre o caminho nas barras)
  String _formatarDataParaColecao(String data) {
    return data.replaceAll(' ', '').replaceAll('/', '-');
  }

  // Retorna a referência da coleção específica daquela data para o usuário logado
  CollectionReference _getColecaoPorData(String data) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final dataLimpa = _formatarDataParaColecao(data);

    // Caminho no banco: usuarios -> [UID do usuário] -> [18-11-2026] -> [tarefas]
    return _db
        .collection('usuarios')
        .doc(user.uid)
        .collection(dataLimpa);
  }

  // 1. Adicionar nova tarefa dentro da coleção da data
  Future<void> adicionarTarefa({
    required String titulo,
    required String data,
  }) async {
    await _getColecaoPorData(data).add({
      'titulo': titulo,
      'concluida': false,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  // 2. Ler tarefas em tempo real daquela data específica
  Stream<QuerySnapshot> getTarefasStream({
    required bool concluida,
    required String data,
  }) {
    if (_auth.currentUser == null) {
      return const Stream.empty();
    }

    return _getColecaoPorData(data)
        .where('concluida', isEqualTo: concluida)
        .snapshots();
  }

  // 3. Alternar status
  Future<void> alternarStatusTarefa({
    required String docId,
    required bool statusAtual,
    required String data,
  }) async {
    await _getColecaoPorData(data).doc(docId).update({
      'concluida': !statusAtual,
    });
  }

  // 4. Excluir tarefa
  Future<void> excluirTarefa({
    required String docId,
    required String data,
  }) async {
    await _getColecaoPorData(data).doc(docId).delete();
  }
}