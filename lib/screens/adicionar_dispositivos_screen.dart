import 'package:flutter/material.dart';
import '../services/device_service.dart';

class AdicionarDispositivosScreen extends StatefulWidget {
  const AdicionarDispositivosScreen({super.key});

  @override
  State<AdicionarDispositivosScreen> createState() =>
      _AdicionarDispositivosScreenState();
}

class _AdicionarDispositivosScreenState
    extends State<AdicionarDispositivosScreen> {
  final _deviceService = DeviceService();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _ipController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _tipoSelecionado;
  String? _salaSelecionada;
  bool _isLoading = false;
  int _etapaAtual = 0;

  final List<Map<String, dynamic>> _tiposDispositivos = [
    {
      'nome': 'Computador',
      'tipo': 'computador',
      'icon': Icons.computer,
      'descricao': 'Computadores e desktops',
    },
    {
      'nome': 'Projetor',
      'tipo': 'projetor',
      'icon': Icons.tv,
      'descricao': 'Projetores e displays',
    },
    {
      'nome': 'Iluminação',
      'tipo': 'iluminacao',
      'icon': Icons.lightbulb,
      'descricao': 'Lâmpadas e iluminação inteligente',
    },
    {
      'nome': 'Ar Condicionado',
      'tipo': 'ar_condicionado',
      'icon': Icons.ac_unit,
      'descricao': 'Climatização e ventilação',
    },
    {
      'nome': 'Outro',
      'tipo': 'outro',
      'icon': Icons.devices_other,
      'descricao': 'Outros dispositivos',
    },
  ];

  final List<String> _salas = [
    'Lab 1',
    'Lab 2',
    'Lab 3',
    'Sala de Reuniões',
    'Auditório',
    'Biblioteca',
    'Recepção',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _ipController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _adicionarDispositivo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo do dispositivo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_salaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a sala do dispositivo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _deviceService.createDevice(
      nome: _nomeController.text.trim(),
      ip: _ipController.text.trim(),
      tipo: _tipoSelecionado!,
      sala: _salaSelecionada!,
      descricao: _descricaoController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(result['message'] ?? 'Dispositivo adicionado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true); 
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro ao adicionar dispositivo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _proximaEtapa() {
    if (_tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um tipo de dispositivo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _etapaAtual = 1;
    });
  }

  void _voltarEtapa() {
    setState(() {
      _etapaAtual = 0;
    });
  }

  Future<void> _adicionarNovaSala() async {
    final novaSala = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Nova Sala'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Nome da Sala',
              hintText: 'Ex: Lab 4',
              prefixIcon: const Icon(Icons.meeting_room),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (novaSala != null && novaSala.isNotEmpty) {
      setState(() {
        if (!_salas.contains(novaSala)) {
          _salas.add(novaSala);
        }
        _salaSelecionada = novaSala;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _etapaAtual == 0 ? () => Navigator.pop(context) : _voltarEtapa,
        ),
        title: Text(_etapaAtual == 0
            ? 'Adicionar Dispositivo'
            : 'Configurar Dispositivo'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _etapaAtual == 0
              ? _buildEtapaSelecaoTipo()
              : _buildEtapaConfiguracao(),
    );
  }

  Widget _buildEtapaSelecaoTipo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStepIndicator(1, true),
                Expanded(child: _buildStepLine(false)),
                _buildStepIndicator(2, false),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              'Selecione o tipo de dispositivo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha o tipo que melhor descreve seu dispositivo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _tiposDispositivos.length,
              itemBuilder: (context, index) {
                final tipo = _tiposDispositivos[index];
                final isSelected = _tipoSelecionado == tipo['tipo'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tipoSelecionado = tipo['tipo'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.15)
                          : Theme.of(context).cardColor,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            tipo['icon'],
                            size: 32,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tipo['nome'],
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            tipo['descricao'],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _tipoSelecionado == null ? null : _proximaEtapa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtapaConfiguracao() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStepIndicator(1, true),
                  Expanded(child: _buildStepLine(true)),
                  _buildStepIndicator(2, true),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Configure seu dispositivo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha as informações do dispositivo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Dispositivo *',
                  hintText: 'Ex: Computador Lab 1',
                  prefixIcon: const Icon(Icons.devices),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do dispositivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: 'Endereço IP *',
                  hintText: 'Ex: 192.168.1.100',
                  prefixIcon: const Icon(Icons.router),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço IP';
                  }
                  final ipRegex =
                      RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
                  if (!ipRegex.hasMatch(value)) {
                    return 'Insira um IP válido (ex: 192.168.1.100)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _salaSelecionada,
                decoration: InputDecoration(
                  labelText: 'Sala *',
                  prefixIcon: const Icon(Icons.meeting_room),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Adicionar nova sala',
                    onPressed: _adicionarNovaSala,
                  ),
                ),
                items: _salas.map((sala) {
                  return DropdownMenuItem(
                    value: sala,
                    child: Text(sala),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _salaSelecionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma sala';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Adicione detalhes sobre o dispositivo',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'O dispositivo será adicionado com status offline. Certifique-se de que está conectado à rede.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _adicionarDispositivo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Adicionar Dispositivo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _voltarEtapa,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive
          ? Theme.of(context).colorScheme.primary
          : Colors.grey.shade300,
    );
  }
}
