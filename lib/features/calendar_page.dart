import 'dart:ui';

import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.dataInicial});

  final DateTime dataInicial;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _dataSelecionada;
  late DateTime _mesExibido;

  static const _verde = Color(0xFF86FA43);
  static const _ciano = Colors.cyanAccent;
  static const _diasDaSemana = [
    'DOM',
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SAB',
  ];

  @override
  void initState() {
    super.initState();
    _dataSelecionada = _semHorario(widget.dataInicial);
    _mesExibido = DateTime(_dataSelecionada.year, _dataSelecionada.month);
  }

  DateTime _semHorario(DateTime data) =>
      DateTime(data.year, data.month, data.day);

  String _nomeDoMes(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return meses[mes - 1];
  }

  void _mudarMes(int valor) {
    setState(
      () => _mesExibido = DateTime(_mesExibido.year, _mesExibido.month + valor),
    );
  }

  List<DateTime?> _diasDoMes() {
    final primeiroDia = DateTime(_mesExibido.year, _mesExibido.month, 1);
    final quantidade = DateTime(_mesExibido.year, _mesExibido.month + 1, 0).day;
    final dias = <DateTime?>[
      ...List<DateTime?>.filled(primeiroDia.weekday % 7, null),
    ];
    for (var dia = 1; dia <= quantidade; dia++) {
      dias.add(DateTime(_mesExibido.year, _mesExibido.month, dia));
    }
    return dias;
  }

  bool _mesmaData(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')} / '
        '${data.month.toString().padLeft(2, '0')} / ${data.year}';
  }

  Widget _buildCabecalho() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
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
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [_verde, _ciano],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Usuário teste',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
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
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [_verde, _ciano],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoNavegacao(IconData icone, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icone, color: Colors.white70, size: 20),
      ),
    );
  }

  Widget _buildCalendario() {
    final dias = _diasDoMes();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_nomeDoMes(_mesExibido.month)} ${_mesExibido.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                _botaoNavegacao(Icons.chevron_left, () => _mudarMes(-1)),
                const SizedBox(width: 8),
                _botaoNavegacao(Icons.chevron_right, () => _mudarMes(1)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: _diasDaSemana
              .map(
                (dia) => Expanded(
                  child: Text(
                    dia,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dias.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 7,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (_, index) {
            final dia = dias[index];
            if (dia == null) return const SizedBox.shrink();
            final selecionado = _mesmaData(dia, _dataSelecionada);
            return GestureDetector(
              onTap: () => setState(() => _dataSelecionada = dia),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: selecionado
                      ? const LinearGradient(colors: [_verde, _ciano])
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${dia.day}',
                  style: TextStyle(
                    color: selecionado ? Colors.black : Colors.white70,
                    fontSize: 11,
                    fontWeight: selecionado
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/espaco.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: _buildCabecalho(),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Selecionar data',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildCalendario(),
                                const SizedBox(height: 10),
                                Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white70,
                                            padding: EdgeInsets.zero,
                                            shape:
                                                const RoundedRectangleBorder(),
                                          ),
                                          onPressed: () => setState(() {
                                            _dataSelecionada = _semHorario(
                                              DateTime.now().toLocal(),
                                            );
                                            _mesExibido = DateTime(
                                              _dataSelecionada.year,
                                              _dataSelecionada.month,
                                            );
                                          }),
                                          child: const Text(
                                            'Hoje',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: _verde,
                                            padding: EdgeInsets.zero,
                                            shape:
                                                const RoundedRectangleBorder(),
                                          ),
                                          onPressed: () => Navigator.pop(
                                            context,
                                            _dataSelecionada,
                                          ),
                                          child: const Text(
                                            'Confirmar',
                                            style: TextStyle(
                                              color: _verde,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
