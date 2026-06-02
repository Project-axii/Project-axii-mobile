<div align="center">

<img src="https://lfcostldktmoevensqdj.supabase.co/storage/v1/object/public/axii/white-logo.svg" alt="AXII Logo" width="120" />

# AXII — Aplicativo Mobile

**Aplicativo móvel do sistema AXII para controle de equipamentos em salas de aula, desenvolvido como Trabalho de Conclusão de Curso do Curso Técnico em Informática da ETEC de Mauá.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-suportado-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![iOS](https://img.shields.io/badge/iOS-suportado-000000?logo=apple&logoColor=white)](https://developer.apple.com/)
[![Versão](https://img.shields.io/badge/versão-1.1.0-blue)](pubspec.yaml)
[![Licença MIT](https://img.shields.io/badge/licença-MIT-blue)](LICENSE)

</div>

---

## Sobre o Projeto

O **AXII Mobile** é o aplicativo para Android e iOS do sistema AXII, que permite a professores e gestores controlar dispositivos tecnológicos de salas de aula diretamente pelo celular — computadores, projetores, iluminação e ar-condicionado — em qualquer lugar da instituição.

O app se comunica com a mesma API PHP compartilhada com o painel web, garantindo sincronização em tempo real entre todas as interfaces do sistema. A URL do servidor é descoberta automaticamente, sem necessidade de configuração manual.

O sistema AXII completo é composto por:
- **Mobile** (este repositório) — controle e monitoramento pelo celular
- **Web** — painel de controle via navegador
- **Desktop** — cliente instalado nos computadores das salas que recebe e executa os comandos

---

## Funcionalidades

### Tela Inicial (Início)
- Saudação personalizada por horário (Bom dia / Boa tarde / Boa noite)
- Foto e nome do usuário logado
- Acesso rápido às funcionalidades principais

### Dispositivos
- Lista de todos os dispositivos cadastrados por sala
- Ligar/desligar dispositivos individualmente
- Controle em grupo por categoria de dispositivo
- Visualização do status em tempo real: **Online**, **Offline**, **Manutenção**
- Detalhes completos de cada dispositivo (IP, tipo, sala, última conexão)
- Cadastro de novos dispositivos

**Tipos de dispositivos suportados:**

| Tipo | Descrição |
|---|---|
| `computador` | Computadores e notebooks |
| `projetor` | Projetores multimídia |
| `iluminacao` | Sistemas de iluminação |
| `ar_condicionado` | Ar-condicionado |
| `outro` | Outros equipamentos |

### Monitoramento e Estatísticas
- Monitoramento em tempo real do status de todos os dispositivos
- Estatísticas gerais da instituição (total, online, offline, manutenção)
- Histórico de ações realizadas no sistema

### Rotinas
- Criação de rotinas automatizadas (ex: ligar todos os computadores do Lab 1 às 7h)
- Ativação e desativação de rotinas
- Execução manual imediata de rotinas
- Edição e exclusão de rotinas existentes

### Listas e Notas
- Criação de listas de tarefas e anotações
- Marcação de itens como concluídos
- Exclusão de listas

### Notificações
- Central de notificações do sistema
- Marcar notificações como lidas
- Exclusão de notificações

### Alarmes e Calendário
- Alarmes e timers integrados
- Calendário para agendamento de eventos e ações

### Configurações e Perfil
- Edição de nome e e-mail
- Upload de foto de perfil
- Alteração de senha
- Configurações gerais do sistema

---

## Tecnologias

| Tecnologia | Versão | Uso |
|---|---|---|
| [Flutter](https://flutter.dev/) | 3.x | Framework multiplataforma |
| [Dart](https://dart.dev/) | ≥ 3.0 | Linguagem de programação |
| [http](https://pub.dev/packages/http) | ^1.0.0 | Requisições HTTP à API |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.0.0 | Persistência local (token, dados do usuário) |
| [image_picker](https://pub.dev/packages/image_picker) | ^1.0.7 | Seleção de foto de perfil da galeria/câmera |
| [mime](https://pub.dev/packages/mime) | ^1.0.4 | Detecção de tipo de arquivo |
| [http_parser](https://pub.dev/packages/http_parser) | ^4.0.2 | Upload de arquivos multipart |

---

## Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada — inicializa API e tema
├── models/
│   └── device.dart                    # Modelos Device e Room (com fromJson/toJson)
├── screens/
│   ├── splash_screen.dart             # Splash com verificação automática de sessão
│   ├── login_screen.dart              # Tela de login
│   ├── cadastro_screen.dart           # Tela de cadastro de novo usuário
│   ├── esqueceu_senha_screen.dart     # Recuperação de senha
│   ├── axii_app.dart                  # App principal com navegação inferior
│   ├── inicio_screen.dart             # Tela inicial com saudação e atalhos
│   ├── dispositivos_screen.dart       # Lista de dispositivos por sala
│   ├── detalhes_dispositivo_screen.dart  # Detalhes e controle de um dispositivo
│   ├── adicionar_dispositivos_screen.dart # Cadastro de novo dispositivo
│   ├── monitoramento_screen.dart      # Monitoramento em tempo real
│   ├── estatisticas_screen.dart       # Estatísticas e indicadores
│   ├── historico_screen.dart          # Histórico de ações
│   ├── rotinas_screen.dart            # Lista de rotinas automatizadas
│   ├── criar_editar_rotina_screen.dart # Criar/editar rotina
│   ├── listas_notas_screen.dart       # Listas e anotações
│   ├── alarmes_timers_screen.dart     # Alarmes e timers
│   ├── calendario_screen.dart         # Calendário
│   ├── config_calendario_screen.dart  # Configurações do calendário
│   ├── notificacoes_screen.dart       # Central de notificações
│   ├── configuracoes_screen.dart      # Configurações gerais
│   ├── config_geral_screen.dart       # Config. gerais do sistema
│   ├── config_informacoes_screen.dart # Informações do app
│   ├── change_password_screen.dart    # Alteração de senha
│   ├── perfil_screen.dart             # Perfil do usuário
│   ├── edit_profile_screen.dart       # Edição de perfil
│   └── mais_screen.dart               # Menu "Mais" com acesso a todas as funções
├── services/
│   ├── api_config.dart                # Configuração e descoberta dinâmica da URL da API
│   ├── auth_service.dart              # Autenticação, sessão e token JWT
│   ├── device_service.dart            # CRUD de dispositivos
│   ├── list_service.dart              # Gerenciamento de listas e notas
│   ├── notification_service.dart      # Gerenciamento de notificações
│   ├── profile_service.dart           # Atualização de perfil e foto
│   └── routine_service.dart           # Gerenciamento de rotinas
└── widgets/
    └── bottom_navigation.dart         # Barra de navegação inferior
```

---

## Navegação

O app usa uma **barra de navegação inferior** com 3 abas principais:

| Aba | Ícone | Conteúdo |
|---|---|---|
| **Início** | 🏠 | Saudação, atalhos rápidos e acesso ao perfil |
| **Dispositivos** | 💡 | Lista e controle de dispositivos por sala |
| **Mais** | ☰ | Acesso a todas as demais funcionalidades |

A tela **Mais** dá acesso a: Monitoramento, Estatísticas, Histórico, Listas, Lembretes, Rotinas, Alarmes, Calendário e Configurações.

---

## Comunicação com a API

A URL do servidor backend é descoberta automaticamente na inicialização do app, consultando um arquivo JSON hospedado no repositório de gateway do projeto:

```
https://raw.githubusercontent.com/Project-axii/Project-axii-gateway/refs/heads/main/sistema.json
```

Se a URL não estiver disponível, o app usa uma URL de fallback (ngrok) configurada em `lib/services/api_config.dart`.

### Endpoints utilizados

| Grupo | Endpoint | Descrição |
|---|---|---|
| **Auth** | `auth/login.php` | Login |
| | `auth/register.php` | Cadastro |
| | `auth/forgot_password.php` | Recuperação de senha |
| | `auth/validate_token.php` | Validação de sessão |
| **Dispositivos** | `devices/list.php` | Listar dispositivos |
| | `devices/create.php` | Cadastrar dispositivo |
| | `devices/toggle.php` | Ligar/desligar dispositivo |
| | `devices/toggle_group.php` | Ligar/desligar grupo |
| | `devices/update.php` | Atualizar status |
| | `devices/rooms.php` | Listar salas |
| **Rotinas** | `routine/list.php` | Listar rotinas |
| | `routine/create.php` | Criar rotina |
| | `routine/update.php` | Atualizar rotina |
| | `routine/delete.php` | Excluir rotina |
| | `routine/toggle.php` | Ativar/desativar rotina |
| | `routine/execute.php` | Executar rotina manualmente |
| **Listas** | `list/list.php` | Listar listas |
| | `list/create.php` | Criar lista |
| | `list/delete.php` | Excluir lista |
| | `list/itens.php` | Itens de uma lista |
| | `list/toggle_item.php` | Marcar/desmarcar item |
| | `list/update.php` | Atualizar lista |
| **Notificações** | `notifications/read.php` | Ler notificações |
| | `notifications/mark_read.php` | Marcar como lida |
| | `notifications/delete.php` | Excluir notificação |
| **Usuário** | `user/update_profile.php` | Atualizar perfil |
| | `user/update_password.php` | Alterar senha |
| | `user/validate_password.php` | Validar senha atual |
| | `user/update_photo.php` | Upload de foto |

A autenticação usa **JWT Bearer Token**, armazenado localmente com `shared_preferences`.

---

## Como rodar localmente

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x ou superior
- [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/) (para iOS)
- Emulador ou dispositivo físico conectado

### Instalação

```bash
# Clone o repositório
git clone https://github.com/Project-axii/Project-axii-mobile.git
cd Project-axii-mobile

# Instale as dependências
flutter pub get
```

### Executar o app

```bash
# Verificar dispositivos disponíveis
flutter devices

# Rodar no dispositivo/emulador
flutter run
```

> **Atenção:** o app busca a URL da API automaticamente. Certifique-se de ter conexão com a internet na inicialização para que o gateway seja consultado corretamente.

### Build de produção

```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle para Play Store)
flutter build appbundle --release

# iOS (requer Mac com Xcode)
flutter build ios --release
```

---

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
