class Device {
  final int id;
  final String nome;
  final String ip;
  final String tipo;
  final String sala;
  final String? descricao;
  final String status;
  final bool ativo;
  final String dataCadastro;
  final String? ultimaConexao;

  Device({
    required this.id,
    required this.nome,
    required this.ip,
    required this.tipo,
    required this.sala,
    this.descricao,
    required this.status,
    required this.ativo,
    required this.dataCadastro,
    this.ultimaConexao,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      nome: json['nome'],
      ip: json['ip'],
      tipo: json['tipo'],
      sala: json['sala'],
      descricao: json['descricao'],
      status: json['status'],
      ativo: json['ativo'],
      dataCadastro: json['data_cadastro'],
      ultimaConexao: json['ultima_conexao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'ip': ip,
      'tipo': tipo,
      'sala': sala,
      'descricao': descricao,
      'status': status,
      'ativo': ativo,
      'data_cadastro': dataCadastro,
      'ultima_conexao': ultimaConexao,
    };
  }

  bool get isOnline => status == 'online';

  Device copyWith({
    int? id,
    String? nome,
    String? ip,
    String? tipo,
    String? sala,
    String? descricao,
    String? status,
    bool? ativo,
    String? dataCadastro,
    String? ultimaConexao,
  }) {
    return Device(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ip: ip ?? this.ip,
      tipo: tipo ?? this.tipo,
      sala: sala ?? this.sala,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ultimaConexao: ultimaConexao ?? this.ultimaConexao,
    );
  }
}

class Room {
  final String name;
  final int devices;
  final int online;
  final int offline;

  Room({
    required this.name,
    required this.devices,
    required this.online,
    required this.offline,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      devices: json['devices'],
      online: json['online'],
      offline: json['offline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'devices': devices,
      'online': online,
      'offline': offline,
    };
  }

  double get onlinePercentage {
    if (devices == 0) return 0;
    return (online / devices) * 100;
  }
}
