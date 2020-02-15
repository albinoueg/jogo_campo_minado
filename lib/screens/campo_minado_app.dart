import 'package:campo_minado/components/resultado_widget.dart';
import 'package:campo_minado/components/tabuleiro_widget.dart';
import 'package:campo_minado/models/campo.dart';
import 'package:campo_minado/models/explossao_exception.dart';
import 'package:campo_minado/models/tabuleiro.dart';
import 'package:flutter/material.dart';

class CampoMinadoApp extends StatefulWidget {
  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinadoApp> {
  bool _venceu;
  Tabuleiro _tabuleiro;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: ResultadoWidget(
          venceu: _venceu,
          onReiniciar: _reiniciar,
        ),
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TabuleiroWidget(
                tabuleiro:
                    _getTabuleiro(constraints.maxWidth, constraints.maxHeight),
                onAbrir: _abrir,
                onAlternarMarcacao: _alternarMarcacao,
              );
            },
          ),
        ),
      ),
    );
  }

  void _abrir(Campo c) {
    if (_venceu != null) {
      return;
    }
    setState(() {
      try {
        c.abrir();
        if (_tabuleiro.resolvido) {
          _venceu = true;
        }
      } on ExplosaoException {
        _venceu = false;
        _tabuleiro.revelarBombas();
      }
    });
  }

  void _alternarMarcacao(Campo c) {
    if (_venceu != null) {
      return;
    }
    setState(() {
      c.alternarMarcacao();
      if (_tabuleiro.resolvido) {
        _venceu = true;
      }
    });
  }

  Tabuleiro _getTabuleiro(double largura, double altura) {
    if (_tabuleiro == null) {
      int qtdeColunas = 15;
      double tamanhoCampo = largura / qtdeColunas;
      int qtdeLinhas = (altura / tamanhoCampo).floor();

      _tabuleiro =
          Tabuleiro(linhas: qtdeLinhas, colunas: qtdeColunas, qtdBombas: 60);
    }
    return _tabuleiro;
  }

  void _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }
}
