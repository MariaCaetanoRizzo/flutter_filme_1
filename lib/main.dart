import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _indicePersonagemAtual = 0;
  bool _carregandoElenco = true;
  String? _erroElenco;

  // As 4 chaves necessárias para a rolagem automática
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Dados dos 8 personagens para o carrossel animado
  List<Map<String, dynamic>> _elencoDados = [];

  @override
  void initState() {
    super.initState();
    _carregarElenco();
  }

  Future<void> _carregarElenco() async {
    try {
      final arquivo = await rootBundle.loadString('json/arquivo.json');
      final dados = jsonDecode(arquivo) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _elencoDados = dados
            .map((personagem) => Map<String, dynamic>.from(personagem as Map))
            .toList();
        _carregandoElenco = false;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _erroElenco = 'Não foi possível carregar o elenco: ${erro.toString()}';
        _carregandoElenco = false;
      });
    }
  }

  void _proximoPersonagem() {
    if (_indicePersonagemAtual < _elencoDados.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _personagemAnterior() {
    if (_indicePersonagemAtual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        _elencoDados.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _rolarParaSecao(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: Container(
        color: Colors.grey,
        child: Center(
          child: SizedBox(
            width: 450,
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 224, 107, 107),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 112, 32, 32),
                centerTitle: true,
                title: const Text(
                  'Querida, Encolhi as crianças',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(228, 222, 222, 1),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const HistoriaPage()),
                          child: const Text(
                            'História',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _rolarParaSecao(_secaoElencoKey),
                          child: const Text(
                            'Elenco',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const CuriosidadesPage()),
                          child: const Text(
                            'Curiosidades',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const RapazesPage()),
                          child: const Text(
                            'Rapazes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 128, 54, 54),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              4,
                              25,
                              71,
                            ).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'img/queridacapa.png',
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              Image.asset(
                                'img/logo.png',
                                height: 90,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Seção História
                          Column(
                            key: _secaoHistoriaKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'História',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/history.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      236,
                                      17,
                                      17,
                                    ),
                                    foregroundColor: const Color.fromARGB(255, 250, 246, 246),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const HistoriaPage()),
                                  child: const Text(
                                    'Ver Mais História',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção Elenco
                          Column(
                            key: _secaoElencoKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Elenco',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (_carregandoElenco)
                                const SizedBox(
                                  height: 280,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 241, 237, 237),
                                    ),
                                  ),
                                )
                              else if (_erroElenco != null)
                                SizedBox(
                                  height: 280,
                                  child: Center(
                                    child: Text(
                                      _erroElenco!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              else
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      onPressed: _personagemAnterior,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 280,
                                        child: PageView.builder(
                                          controller: _pageController,
                                          itemCount: _elencoDados.length,
                                          onPageChanged: (index) {
                                            setState(() {
                                              _indicePersonagemAtual = index;
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            final personagem =
                                                _elencoDados[index];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _construirCardImagem(
                                                  personagem['imagem']
                                                      as String?,
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  personagem['nome'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Ator: ${personagem['ator'] as String}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white70,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      onPressed: _proximoPersonagem,
                                    ),
                                  ],
                                ),
                              if (!_carregandoElenco && _erroElenco == null)
                                Center(
                                  child: Text(
                                    '${_indicePersonagemAtual + 1} de ${_elencoDados.length}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção Curiosidades
                          Column(
                            key: _secaoCuriosidadesKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Curiosidades',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/chalapiquiso.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      204,
                                      24,
                                      11,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => _navegarParaPagina(
                                    const CuriosidadesPage(),
                                  ),
                                  child: const Text(
                                    'Ver Mais Curiosidades',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção Rapazes
                          Column(
                            key: _secaoRapazesKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rapazes',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/rapazes.jpeg',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      255,
                                      36,
                                      36,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const RapazesPage()),
                                  child: const Text(
                                    'Ver Mais ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirCardImagem(String? path) {
    final imagemValida =
        path != null &&
        path.trim().isNotEmpty &&
        (path.startsWith('http://') || path.startsWith('https://'));
    final assetValido = path != null && path.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 131, 70, 70).withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: imagemValida
            ? Image.network(
                path,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Image.asset(
                    'img/logo.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.contain,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'img/logo.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              )
            : assetValido
            ? Image.asset(
                path,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'img/logo.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                'img/logo.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'História',
      imagem: 'img/history.png',
      texto:
          'Wayne Szalinski é um inventor que trabalha em uma máquina capaz de encolher objetos. Durante uma experiência no sótão, uma bola de beisebol atravessa a janela e aciona acidentalmente o equipamento. O raio atinge Amy e Nick Szalinski e os vizinhos Russ Jr. e Ron Thompson, reduzindo as quatro crianças a poucos centímetros de altura. Como Wayne e Diane não percebem o acidente, as crianças acabam no lixo e são levadas para o quintal, que passa a parecer uma enorme selva. Perdidos entre folhas de grama, gotas de água e objetos gigantes, eles precisam encontrar o caminho de volta para casa. No percurso, enfrentam os aspersores, uma abelha e outros perigos, além de fazer amizade com uma formiga que chamam de Antie. Quando um escorpião ameaça o grupo, Antie tenta protegê-los e acaba morrendo. Enquanto isso, Wayne e Diane procuram pelos filhos e descobrem que a máquina foi ativada pela bola de beisebol. Com a ajuda do cachorro Quark, as crianças conseguem chamar a atenção dos pais. Wayne reconstrói o funcionamento da máquina e devolve todos ao tamanho normal.',
      itens: [],
    );
  }
}

class CuriosidadesPage extends StatelessWidget {
  const CuriosidadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'Curiosidades',
      imagem: 'img/chalapiquiso.png',
      texto:
          'O filme transformou objetos comuns em cenários gigantescos. Uma folha de grama vira uma floresta, uma formiga parece um animal enorme e uma gota de água ganha proporções impressionantes.',
      itens: [
        'A produção foi uma das primeiras comédias a usar efeitos visuais para criar personagens minúsculos.',
        'Os sons do quintal foram reforçados para deixar cada passo e movimento mais divertido.',
        'O sucesso do filme levou a continuações e a uma série de televisão.',
      ],
    );
  }
}

class RapazesPage extends StatelessWidget {
  const RapazesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'Rapazes',
      imagem: 'img/rapazes.jpeg',
      texto:
          'Conheça os desenvolvedores responsáveis pela documentação, pela aplicação mobile e pelo jogo inspirado no filme.',
      itens: [
        'Arthur Paixão: desenvolvedor da documentação, da configuração do GitHub e do front-end do jogo que será criado com base no filme.',
        'Maria Caetano Rizzo: responsável pelo back-end e pelo front-end completo da aplicação mobile.',
        'Rihan de Jesus: responsável pelo front-end e pelo back-end do desenvolvimento do jogo criado.',
      ],
    );
  }
}

class PaginaDetalhes extends StatelessWidget {
  final String titulo;
  final String imagem;
  final String texto;
  final List<String> itens;

  const PaginaDetalhes({
    super.key,
    required this.titulo,
    required this.imagem,
    required this.texto,
    required this.itens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: SizedBox(
          width: 450,
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 220, 220),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 112, 32, 32),
              centerTitle: true,
              title: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 168, 98, 98),
                ),
              ),
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 128, 54, 54),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            4,
                            25,
                            71,
                          ).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            imagem,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          texto,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ...itens.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Voltar para a página inicial'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                236,
                                17,
                                17,
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
