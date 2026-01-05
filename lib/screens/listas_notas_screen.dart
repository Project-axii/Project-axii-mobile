import 'package:flutter/material.dart';
import '../services/list_service.dart';

class ListasNotasScreen extends StatefulWidget {
  const ListasNotasScreen({super.key});

  @override
  State<ListasNotasScreen> createState() => _ListasNotasScreenState();
}

class _ListasNotasScreenState extends State<ListasNotasScreen> {
  final _listaService = ListaService();
  List<Map<String, dynamic>> _listas = [];
  bool _isLoading = true;

  final Map<String, Color> _coresDisponiveis = {
    'blue': Colors.blue,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'green': Colors.green,
    'red': Colors.red,
    'pink': Colors.pink,
    'teal': Colors.teal,
  };

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final listas = await _listaService.listar();

      setState(() {
        _listas = listas.map((lista) {
          return {
            'id': lista['id'],
            'titulo': lista['titulo'],
            'cor': _coresDisponiveis[lista['cor']] ?? Colors.blue,
            'corNome': lista['cor'],
            'itens':
                (lista['itens'] as List).map((item) => item['texto']).toList(),
            'itensCompletos': lista['itens'],
            'concluidos': lista['concluidos'] ?? 0,
            'total_itens': lista['total_itens'] ?? 0,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar listas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Listas e Notas',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF8B5CF6)),
            onPressed: () {
              _mostrarDialogoNovaLista();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B5CF6),
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarListas,
              color: const Color(0xFF8B5CF6),
              child: _listas.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.list_alt,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma lista criada',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Toque no + para criar sua primeira lista',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Organize suas tarefas e materiais',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._listas.map((lista) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildListaCard(lista),
                            )),
                      ],
                    ),
            ),
    );
  }

  Widget _buildListaCard(Map<String, dynamic> lista) {
    final totalItens = lista['total_itens'] as int;
    final concluidos = lista['concluidos'] as int;
    final progresso = totalItens > 0 ? concluidos / totalItens : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _mostrarDetalhesLista(lista);
          },
          onLongPress: () {
            _mostrarOpcoesLista(lista);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: lista['cor'] as Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lista['titulo'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$concluidos de $totalItens concluídos',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                if (totalItens > 0) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progresso,
                      backgroundColor: const Color(0xFF2A2A2A),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(lista['cor'] as Color),
                      minHeight: 6,
                    ),
                  ),
                ],
                if ((lista['itens'] as List).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (lista['itens'] as List).take(3).map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalhesLista(Map<String, dynamic> lista) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DetalhesListaSheet(
        lista: lista,
        onUpdate: _carregarListas,
        listaService: _listaService,
      ),
    );
  }

  void _mostrarOpcoesLista(Map<String, dynamic> lista) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
              title:
                  const Text('Editar', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _mostrarDialogoEditarLista(lista);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title:
                  const Text('Deletar', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _confirmarDeletarLista(lista);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoNovaLista() {
    final TextEditingController controller = TextEditingController();
    String corSelecionada = 'blue';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Nova Lista',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome da lista',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cor:',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _coresDisponiveis.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setStateDialog(() {
                        corSelecionada = entry.key;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: corSelecionada == entry.key
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    final resultado = await _listaService.criar({
                      'titulo': controller.text,
                      'cor': corSelecionada,
                    });

                    if (resultado['success']) {
                      Navigator.pop(context);
                      _carregarListas();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resultado['message'] ??
                              'Lista criada com sucesso!'),
                          backgroundColor: const Color(0xFF8B5CF6),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              resultado['message'] ?? 'Erro ao criar lista'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao criar lista: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
              ),
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoEditarLista(Map<String, dynamic> lista) {
    final TextEditingController controller =
        TextEditingController(text: lista['titulo']);
    String corSelecionada = lista['corNome'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Editar Lista',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome da lista',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cor:',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _coresDisponiveis.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setStateDialog(() {
                        corSelecionada = entry.key;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: corSelecionada == entry.key
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    final resultado = await _listaService.atualizar({
                      'id': lista['id'],
                      'titulo': controller.text,
                      'cor': corSelecionada,
                    });

                    if (resultado['success']) {
                      Navigator.pop(context);
                      _carregarListas();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resultado['message'] ??
                              'Lista atualizada com sucesso!'),
                          backgroundColor: const Color(0xFF8B5CF6),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resultado['message'] ??
                              'Erro ao atualizar lista'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar lista: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarDeletarLista(Map<String, dynamic> lista) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente deletar a lista "${lista['titulo']}"? Todos os itens desta lista também serão deletados.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final resultado = await _listaService.deletar(lista['id']);

                if (resultado['success']) {
                  Navigator.pop(context);
                  _carregarListas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(resultado['message'] ??
                          'Lista deletada com sucesso!'),
                      backgroundColor: const Color(0xFF8B5CF6),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(resultado['message'] ?? 'Erro ao deletar lista'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao deletar lista: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}

class _DetalhesListaSheet extends StatefulWidget {
  final Map<String, dynamic> lista;
  final VoidCallback onUpdate;
  final ListaService listaService;

  const _DetalhesListaSheet({
    required this.lista,
    required this.onUpdate,
    required this.listaService,
  });

  @override
  State<_DetalhesListaSheet> createState() => _DetalhesListaSheetState();
}

class _DetalhesListaSheetState extends State<_DetalhesListaSheet> {
  final TextEditingController _novoItemController = TextEditingController();
  List<dynamic> _itens = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _itens = List.from(widget.lista['itensCompletos']);
  }

  @override
  void dispose() {
    _novoItemController.dispose();
    super.dispose();
  }

  Future<void> _adicionarItem() async {
    if (_novoItemController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final resultado = await widget.listaService.adicionarItem(
        widget.lista['id'],
        _novoItemController.text.trim(),
      );

      if (resultado['success']) {
        _novoItemController.clear();
        widget.onUpdate();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(resultado['message'] ?? 'Item adicionado com sucesso!'),
            backgroundColor: const Color(0xFF8B5CF6),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Erro ao adicionar item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleItem(dynamic item) async {
    try {
      final resultado = await widget.listaService.toggleItemConcluido(
        item['id'],
        widget.lista['id'],
      );

      if (resultado['success']) {
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Erro ao atualizar item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletarItem(dynamic item) async {
    try {
      final resultado = await widget.listaService.deletarItem(
        item['id'],
        widget.lista['id'],
      );

      if (resultado['success']) {
        widget.onUpdate();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Item deletado com sucesso!'),
            backgroundColor: const Color(0xFF8B5CF6),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Erro ao deletar item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmarDeletarItem(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente deletar o item "${item['texto']}"?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletarItem(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: widget.lista['cor'] as Color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.lista['titulo'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _novoItemController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Adicionar item...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _adicionarItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _adicionarItem,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF8B5CF6),
                          ),
                        )
                      : const Icon(Icons.add, color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _itens.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum item adicionado',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _itens.length,
                      itemBuilder: (context, index) {
                        final item = _itens[index];
                        final isConcluido = item['concluido'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Dismissible(
                            key: Key(item['id'].toString()),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF1E1E1E),
                                  title: const Text(
                                    'Confirmar Exclusão',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Text(
                                    'Deseja realmente deletar o item "${item['texto']}"?',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Deletar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) => _deletarItem(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isConcluido,
                                    onChanged: (_) => _toggleItem(item),
                                    activeColor: widget.lista['cor'] as Color,
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['texto'],
                                      style: TextStyle(
                                        color: isConcluido
                                            ? Colors.grey
                                            : Colors.white,
                                        fontSize: 16,
                                        decoration: isConcluido
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
