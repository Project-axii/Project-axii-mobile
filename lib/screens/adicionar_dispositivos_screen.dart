import 'package:flutter/material.dart';

class AdicionarDispositivosScreen extends StatefulWidget {
  const AdicionarDispositivosScreen({super.key});

  @override
  State<AdicionarDispositivosScreen> createState() =>
      _AdicionarDispositivosScreenState();
}

class _AdicionarDispositivosScreenState
    extends State<AdicionarDispositivosScreen> {
  String? dispositivoSelecionado;
  bool conectando = false;

  final List<Map<String, dynamic>> dispositivosDisponiveis = [
    {
      'nome': 'Power link',
      'icon': Icons.speaker,
      'descricao': 'Placa de controle dos computadores',
    },
    {
      'nome': 'Nexus',
      'icon': Icons.tv,
      'descricao': 'Placa de controle central',
    },
    {
      'nome': 'Ax-LM',
      'icon': Icons.lightbulb,
      'descricao': 'Controladora de iluminação inteligente',
    },
    {
      'nome': 'Termostato Inteligente',
      'icon': Icons.thermostat,
      'descricao': 'Controle de temperatura automático',
    },
    {
      'nome': 'Câmera de Segurança',
      'icon': Icons.videocam,
      'descricao': 'Monitoramento e gravação em tempo real',
    },
    {
      'nome': 'Plugue Inteligente',
      'icon': Icons.power,
      'descricao': 'Controle remoto de energia',
    },
    {
      'nome': 'Sensor de Movimento',
      'icon': Icons.sensors,
      'descricao': 'Detecção de movimento e presença',
    },
    {
      'nome': 'Fechadura Inteligente',
      'icon': Icons.lock,
      'descricao': 'Controle de acesso remoto',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Adicionar Dispositivo'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de Busca
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar dispositivo...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
              const SizedBox(height: 32),

              // Título
              Text(
                'Dispositivos Disponíveis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(height: 16),

              // Grade de Dispositivos
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: dispositivosDisponiveis.length,
                itemBuilder: (context, index) {
                  final dispositivo = dispositivosDisponiveis[index];
                  final isSelected =
                      dispositivoSelecionado == dispositivo['nome'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        dispositivoSelecionado = dispositivo['nome'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2)
                            : Theme.of(context).cardColor,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
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
                                      .secondary
                                      .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              dispositivo['icon'],
                              size: 32,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            dispositivo['nome'],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              dispositivo['descricao'],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade400,
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

              // Seção de Conexão
              if (dispositivoSelecionado != null) ...[
                Text(
                  'Conectar ${dispositivoSelecionado!}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.wifi,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Certifique-se de que o dispositivo está perto do WiFi',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.power,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Verifique se o dispositivo está ligado',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tenha Bluetooth ativado no seu telefone',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Botão de Conectar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: dispositivoSelecionado == null
                      ? null
                      : _conectarDispositivo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: conectando
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Conectar ${dispositivoSelecionado ?? "Dispositivo"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão Cancelar
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _conectarDispositivo() async {
    setState(() => conectando = true);

    // Simular conexão
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => conectando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$dispositivoSelecionado conectado com sucesso!'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }
}
