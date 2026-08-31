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

  // As 4 chaves necessárias para a rolagem automática
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Dados dos 8 personagens para o carrossel animado
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
      // Colorindo o fundo de cinza por fora da caixinha do celular
      home: Container(
        color: Colors.grey[300], 
        child: Center(
          // 1. SizedBox Limitador na raiz externa do layout
          child: SizedBox(
            width: 450, // Largura máxima do aplicativo inteiro (Corpo + AppBar)
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 112, 32, 32),
                centerTitle: true,
                title: const Text(
                  'Querida, Encolhi as crianças',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 168, 98, 98),
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
                          onPressed: () => _rolarParaSecao(_secaoHistoriaKey),
                          child: const Text('História', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _rolarParaSecao(_secaoElencoKey),
                          child: const Text('Elenco', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _rolarParaSecao(_secaoCuriosidadesKey),
                          child: const Text('Curiosidades', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () => _rolarParaSecao(_secaoRapazesKey),
                          child: const Text('Rapazes', style: TextStyle(color: Colors.white)),
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
                    // O contêiner de fundo marrom/avermelhado herdado do Guia Chileno
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(20), 
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 128, 54, 54),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 4, 25, 71).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Capa do filme com logo sobreposta
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.red,
                                alignment: Alignment.center,
                                child: const Text('Conteúdo História', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção Elenco (Com o carrossel animado adaptado)
                          Column(
                            key: _secaoElencoKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Elenco', 
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios, size: 25, color: Colors.white),
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
                                    icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Colors.white),
                                    onPressed: _proximoPersonagem,
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  '${_indicePersonagemAtual + 1} de ${_elencoDados.length}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white60),
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.orange,
                                alignment: Alignment.center,
                                child: const Text('Conteúdo Curiosidades', style: TextStyle(color: Colors.white)),
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.purple,
                                alignment: Alignment.center,
                                child: const Text('Conteúdo Rapazes', style: TextStyle(color: Colors.white)),
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

  Widget _construirCardImagem(String path) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
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
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset(
          path,
          width: double.infinity,
          height: 170,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
