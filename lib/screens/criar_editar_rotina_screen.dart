import 'package:flutter/material.dart';
import '../services/routine_service.dart';

class CriarEditarRotinaScreen extends StatefulWidget {
  final Map<String, dynamic>? rotina;
  final bool isEdit;

  const CriarEditarRotinaScreen({
    super.key,
    this.rotina,
    this.isEdit = false,
  });

  @override
  State<CriarEditarRotinaScreen> createState() =>
      _CriarEditarRotinaScreenState();
}

class _CriarEditarRotinaScreenState extends State<CriarEditarRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rotinaService = RotinaService();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  TimeOfDay _horarioInicio = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay _horarioFim = const TimeOfDay(hour: 8, minute: 0);
  String _acao = 'ligar';
  bool _ativo = true;

  String _tipoAlvo = 'grupo';
  int? _idAlvoSelecionado;
  List<dynamic> _dispositivos = [];
  List<dynamic> _grupos = [];

  final Map<String, bool> _diasSelecionados = {
    'segunda': false,
    'terca': false,
    'quarta': false,
    'quinta': false,
    'sexta': false,
    'sabado': false,
    'domingo': false,
  };

  final Map<String, String> _diasNomes = {
    'segunda': 'Segunda',
    'terca': 'Terça',
    'quarta': 'Quarta',
    'quinta': 'Quinta',
    'sexta': 'Sexta',
    'sabado': 'Sábado',
    'domingo': 'Domingo',
  };

  final List<Map<String, String>> _acoes = [
    {'value': 'ligar', 'label': 'Ligar'},
    {'value': 'desligar', 'label': 'Desligar'},
    {'value': 'reiniciar', 'label': 'Reiniciar'},
    {'value': 'custom', 'label': 'Personalizado'},
  ];

  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      final dispositivos = await _rotinaService.listarDispositivos();
      final grupos = await _rotinaService.listarGrupos();

      setState(() {
        _dispositivos = dispositivos;
        _grupos = grupos;

        if (_grupos.isNotEmpty && !widget.isEdit) {
          _idAlvoSelecionado = _grupos[0]['id'];
        }
      });

      if (widget.isEdit && widget.rotina != null) {
        _carregarDadosRotina();
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  void _carregarDadosRotina() {
    final rotina = widget.rotina!;

    _nomeController.text = rotina['nome'] ?? '';
    _descricaoController.text = rotina['descricao'] ?? '';

    if (rotina['horario_ini'] != null) {
      final partes = rotina['horario_ini'].split(':');
      _horarioInicio = TimeOfDay(
        hour: int.parse(partes[0]),
        minute: int.parse(partes[1]),
      );
    }

    if (rotina['horario_fim'] != null) {
      final partes = rotina['horario_fim'].split(':');
      _horarioFim = TimeOfDay(
        hour: int.parse(partes[0]),
        minute: int.parse(partes[1]),
      );
    }

    _acao = rotina['acao'] ?? 'ligar';

    _ativo = rotina['ativo'] ?? true;

    if (rotina['id_dispositivo'] != null) {
      _tipoAlvo = 'dispositivo';
      _idAlvoSelecionado = rotina['id_dispositivo'];
    } else if (rotina['id_grupo'] != null) {
      _tipoAlvo = 'grupo';
      _idAlvoSelecionado = rotina['id_grupo'];
    }

    if (rotina['dias_semana'] is List) {
      for (var dia in rotina['dias_semana']) {
        if (_diasSelecionados.containsKey(dia)) {
          _diasSelecionados[dia] = true;
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarHorario(bool isInicio) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isInicio ? _horarioInicio : _horarioFim,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
              hourMinuteTextColor: Colors.white,
              dayPeriodTextColor: Colors.white,
              dialHandColor: const Color(0xFF8B5CF6),
              dialBackgroundColor: const Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _horarioInicio = picked;
        } else {
          _horarioFim = picked;
        }
      });
    }
  }

  String _formatarHorario(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _salvarRotina() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_diasSelecionados.containsValue(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um dia da semana'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_idAlvoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Selecione um ${_tipoAlvo == 'grupo' ? 'grupo' : 'dispositivo'}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final diasSelecionados = _diasSelecionados.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final Map<String, Object?> rotina = {
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'horario_ini': _formatarHorario(_horarioInicio),
        'horario_fim': _formatarHorario(_horarioFim),
        'dias_semana': diasSelecionados,
        'acao': _acao,
        'ativo': _ativo,
      };

      if (_tipoAlvo == 'dispositivo') {
        rotina['id_dispositivo'] = _idAlvoSelecionado;
        rotina['id_grupo'] = null;
      } else {
        rotina['id_grupo'] = _idAlvoSelecionado;
        rotina['id_dispositivo'] = null;
      }

      if (widget.isEdit) {
        rotina['id'] = widget.rotina!['id'];
        final success = await _rotinaService.atualizarRotina(rotina);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rotina atualizada com sucesso!'),
              backgroundColor: Color(0xFF8B5CF6),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        final success = await _rotinaService.criarRotina(rotina);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rotina criada com sucesso!'),
              backgroundColor: Color(0xFF8B5CF6),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
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
            widget.isEdit ? 'Editar Rotina' : 'Nova Rotina',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
          ),
        ),
      );
    }

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
          widget.isEdit ? 'Editar Rotina' : 'Nova Rotina',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Informações Básicas'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration(
                'Nome da rotina',
                Icons.label_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descricaoController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: _buildInputDecoration(
                'Descrição (opcional)',
                Icons.description_outlined,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Aplicar em'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTipoAlvoOption('Grupo', 'grupo', Icons.group),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTipoAlvoOption(
                      'Dispositivo', 'dispositivo', Icons.devices),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildAlvoSelector(),
            const SizedBox(height: 24),

            _buildSectionTitle('Horários'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildHorarioCard(
                    'Início',
                    _horarioInicio,
                    () => _selecionarHorario(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHorarioCard(
                    'Fim',
                    _horarioFim,
                    () => _selecionarHorario(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Dias da Semana'),
            const SizedBox(height: 12),
            _buildDiasSemana(),
            const SizedBox(height: 24),

            _buildSectionTitle('Ação'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _acao,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: _acoes.map((acao) {
                    return DropdownMenuItem<String>(
                      value: acao['value'],
                      child: Text(acao['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _acao = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Status'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rotina Ativa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _ativo
                            ? 'Será executada automaticamente'
                            : 'Apenas execução manual',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _ativo,
                    onChanged: (value) {
                      setState(() {
                        _ativo = value;
                      });
                    },
                    activeColor: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarRotina,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.isEdit ? 'Atualizar Rotina' : 'Criar Rotina',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoAlvoOption(String label, String tipo, IconData icon) {
    final isSelected = _tipoAlvo == tipo;
    return InkWell(
      onTap: () {
        setState(() {
          _tipoAlvo = tipo;
          _idAlvoSelecionado = null; 
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlvoSelector() {
    final lista = _tipoAlvo == 'grupo' ? _grupos : _dispositivos;

    if (lista.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Nenhum ${_tipoAlvo == 'grupo' ? 'grupo' : 'dispositivo'} disponível',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
        value: lista.any((item) => item['id'] == _idAlvoSelecionado)
            ? _idAlvoSelecionado
            : null,
        hint: Text(
          'Selecione um ${_tipoAlvo == 'grupo' ? 'grupo' : 'dispositivo'}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        isExpanded: true,
        dropdownColor: const Color(0xFF1E1E1E),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: lista.map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem<int>(
            value: item['id'],
            child: Text(item['nome'] ?? 'Sem nome'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _idAlvoSelecionado = value;
          });
        },
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: const Color(0xFF8B5CF6)),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildHorarioCard(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatarHorario(time),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF8B5CF6),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiasSemana() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _diasSelecionados.entries.map((entry) {
        final dia = entry.key;
        final selecionado = entry.value;

        return FilterChip(
          label: Text(_diasNomes[dia]!),
          selected: selecionado,
          onSelected: (value) {
            setState(() {
              _diasSelecionados[dia] = value;
            });
          },
          backgroundColor: const Color(0xFF1E1E1E),
          selectedColor: const Color(0xFF8B5CF6),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selecionado ? Colors.white : Colors.grey[400],
            fontWeight: selecionado ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: selecionado ? const Color(0xFF8B5CF6) : Colors.grey[700]!,
          ),
        );
      }).toList(),
    );
  }
}
