import 'package:flutter/material.dart';

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

  int _indicePersonagemAtual = 0;

  // =========================
  // CHAVES DAS SEÇÕES
  // =========================
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // =========================
  // DADOS DO ELENCO
  // =========================
  final List<Map<String, String>> _elencoDados = [
    {'nome': 'Personagem 1', 'ator': 'Ator 1', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 2', 'ator': 'Ator 2', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 3', 'ator': 'Ator 3', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 4', 'ator': 'Ator 4', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 5', 'ator': 'Ator 5', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 6', 'ator': 'Ator 6', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 7', 'ator': 'Ator 7', 'imagem': 'img/logo.png'},
    {'nome': 'Personagem 8', 'ator': 'Ator 8', 'imagem': 'img/logo.png'},
  ];

  // =========================
  // NAVEGAÇÃO DO CAROUSEL
  // =========================
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

  // =========================
  // ROLAR ATÉ UMA SEÇÃO
  // =========================
  void _rolarParaSecao(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
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
      home: Scaffold(
        backgroundColor: Colors.grey,
        
        // =========================
        // APP BAR (LIMITADA)
        // =========================
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 112, 32, 32),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Querida, Encolhi as crianças',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          flexibleSpace: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: const SizedBox.expand(),
            ),
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _botaoMenu('História', () => _rolarParaSecao(_secaoHistoriaKey)),
                        _botaoMenu('Elenco', () => _rolarParaSecao(_secaoElencoKey)),
                        _botaoMenu('Curiosidades', () => _rolarParaSecao(_secaoCuriosidadesKey)),
                        _botaoMenu('Rapazes', () => _rolarParaSecao(_secaoRapazesKey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // =========================
        // CORPO DO APP
        // =========================
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
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
                          color: Colors.black.withValues(alpha: 0.25),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // =========================
                        // CAPA
                        // =========================
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'img/queridacapa.png',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Image.asset(
                              'img/logo.png',
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // =========================
                        // SEÇÃO HISTÓRIA
                        // =========================
                        Column(
                          key: _secaoHistoriaKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _tituloSecao('História'),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'img/logo.png',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Conheça a história de Querida, Encolhi as Crianças.',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const PaginaHistoria()),
                                      );
                                    },
                                    child: const Text('Saiba mais'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // =========================
                        // SEÇÃO ELENCO
                        // =========================
                        Column(
                          key: _secaoElencoKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _tituloSecao('Elenco'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _personagemAnterior,
                                  icon: const Icon(Icons.arrow_back_ios, size: 25, color: Colors.white),
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
                                        final personagem = _elencoDados[index];
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _construirCardImagem(personagem['imagem']!),
                                            const SizedBox(height: 12),
                                            Text(
                                              personagem['nome']!,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Ator: ${personagem['ator']!}',
                                              style: const TextStyle(fontSize: 14, color: Colors.white70),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _proximoPersonagem,
                                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                '${_indicePersonagemAtual + 1} de ${_elencoDados.length}',
                                style: const TextStyle(fontSize: 12, color: Colors.white60),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // =========================
                        // SEÇÃO CURIOSIDADES
                        // =========================
                        Column(
                          key: _secaoCuriosidadesKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _tituloSecao('Curiosidades'),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'img/logo.png',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Descubra fatos interessantes sobre o filme.',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const PaginaCuriosidades()),
                                      );
                                    },
                                    child: const Text('Saiba mais'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // =========================
                        // SEÇÃO RAPAZES
                        // =========================
                        Column(
                          key: _secaoRapazesKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _tituloSecao('Rapazes'),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'img/logo.png',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Conheça os personagens e os rapazes do filme.',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const PaginaRapazes()),
                                      );
                                    },
                                    child: const Text('Saiba mais'),
                                  ),
                                ],
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
    );
  }

  // =========================
  // WIDGETS AUXILIARES
  // =========================
  Widget _botaoMenu(String texto, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tituloSecao(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _construirCardImagem(String path) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          path,
          width: 170,
          height: 170,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ============================================================
// PÁGINAS SECUNDÁRIAS
// ============================================================

class PaginaHistoria extends StatelessWidget {
  const PaginaHistoria({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('História', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 112, 32, 32),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('img/logo.png', width: double.infinity, height: 220, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text('História', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  'Aqui você pode colocar a história completa de Querida, Encolhi as Crianças, contando todos os detalhes da aventura da família Szalinski.',
                  style: TextStyle(fontSize: 17, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaginaCuriosidades extends StatelessWidget {
  const PaginaCuriosidades({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Curiosidades', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 112, 32, 32),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('img/logo.png', width: double.infinity, height: 220, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text('Curiosidades', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  'Aqui você pode colocar várias curiosidades sobre o filme, os atores, a produção, os efeitos especiais e as cenas mais marcantes.',
                  style: TextStyle(fontSize: 17, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaginaRapazes extends StatelessWidget {
  const PaginaRapazes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Rapazes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 112, 32, 32),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('img/logo.png', width: double.infinity, height: 220, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text('Rapazes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  'Aqui você pode apresentar os personagens masculinos do filme, suas características, personalidades e informações sobre cada um deles.',
                  style: TextStyle(fontSize: 17, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
