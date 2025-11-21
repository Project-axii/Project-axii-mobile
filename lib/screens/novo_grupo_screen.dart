import 'package:flutter/material.dart';

class NovoGrupoScreen extends StatefulWidget {
  const NovoGrupoScreen({super.key});

  @override
  State<NovoGrupoScreen> createState() => _NovoGrupoScreenState();
}

class _NovoGrupoScreenState extends State<NovoGrupoScreen> {
  final _nomeController = TextEditingController();
  final _iconesSelecionados = <IconData>[];
  IconData _iconeSelecionado = Icons.home;
  List<bool> _dispositivosSelecionados = [false, false, false];

  final List<IconData> _icones = [
    Icons.home,
    Icons.bed,
    Icons.living,
    Icons.kitchen,
    Icons.work,
    Icons.landscape,
    Icons.shopping_cart,
    Icons.door_front_door,
  ];

  final List<Map<String, dynamic>> _dispositivos = [
    {
      'nome': 'Smart Lâmpada WiFi',
      'icon': Icons.lightbulb,
      'status': 'On-line'
    },
    {'nome': 'Echo Dot de Pedro', 'icon': Icons.speaker, 'status': 'On-line'},
    {
      'nome': 'Alexa neste telefone',
      'icon': Icons.phone_android,
      'status': 'On-line'
    },
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Novo Grupo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do Grupo
            Text(
              'Nome do Grupo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: 'Ex: Sala de Aula',
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 32),

            // Selecionar Ícone
            Text(
              'Escolha um Ícone',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _icones.length,
              itemBuilder: (context, index) {
                final isSelected = _iconeSelecionado == _icones[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _iconeSelecionado = _icones[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Icon(
                      _icones[index],
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Selecionar Dispositivos
            Text(
              'Adicionar Dispositivos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dispositivos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    value: _dispositivosSelecionados[index],
                    onChanged: (value) {
                      setState(() {
                        _dispositivosSelecionados[index] = value ?? false;
                      });
                    },
                    title: Text(_dispositivos[index]['nome']),
                    subtitle: Text(_dispositivos[index]['status']),
                    secondary: Icon(_dispositivos[index]['icon']),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Botões
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nomeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Digite um nome para o grupo')),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Grupo "${_nomeController.text}" criado com sucesso!'),
                    ),
                  );

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Criar Grupo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
