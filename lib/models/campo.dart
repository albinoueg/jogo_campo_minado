import 'package:flutter/foundation.dart';
import 'explossao_exception.dart';

class Campo {
  final int linha;
  final int coluna;
  final List<Campo> visinhos = [];

  bool _aberto = false;
  bool _marcado = false;
  bool _minado = false;
  bool _explodido = false;

  Campo({
    @required this.linha,
    @required this.coluna
  });

  void adicionarVisinho(Campo vizinho) {
    final deltaLinha = (linha - vizinho.linha).abs();
    final deltaColuna = (coluna - vizinho.coluna).abs();

    if (deltaLinha == 0 && deltaColuna == 0) {
      return;
    }
    if (deltaLinha <= 1 && deltaColuna <= 1) {
      visinhos.add(vizinho);
    }
  }

  void abrir() {
    if (_aberto) {
      return;
    }
    _aberto = true;

    if (_minado) {
      _explodido = true;
      throw ExplosaoException();
    }

    if (vizinhacaSegura) {
      visinhos.forEach((v) => v.abrir());
    }
  }

  void revelarBomba() {
    if (_minado) {
      _aberto = true;
    }
  }

  void minar() {
    _minado = true;
  }

  void alternarMarcacao() {
    _marcado = !_marcado;
  }

  void reiniciar() {
    _aberto = false;
    _marcado = false;
    _minado = false;
    _explodido = false;
  }

  bool get minado {
    return _minado;
  }

  bool get explodido {
    return _explodido;
  }

  bool get aberto {
    return _aberto;
  }

  bool get marcado {
    return _marcado;
  }

  bool get resolvido {
    bool minadoEMarcado = minado && marcado;
    bool seguroAberto = !minado && aberto;
    return minadoEMarcado || seguroAberto;
  }

  bool get vizinhacaSegura {
    return visinhos.every((v) => !v._minado);
  }

  int get qtdeMinasNaVisinhaca {
    return visinhos.where((v) => v.minado).length;
  }
}
