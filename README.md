<div align="center">

# 🚀 Lista de Tarefas

### ✨ Organize seu dia. Conquiste suas metas. ✨

Aplicativo multiplataforma de gerenciamento de tarefas desenvolvido com
**Flutter**, **Dart** e **Firebase**.

<p>
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-Linguagem-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black" alt="Firebase"></a>
  <a href="https://github.com/Ca22io/lista_de_tarefas"><img src="https://img.shields.io/badge/status-em%20desenvolvimento-86FA43?logo=github&logoColor=black" alt="Status"></a>
</p>

**[📦 Acessar o repositório](https://github.com/Ca22io/lista_de_tarefas)**

</div>

---

## 📌 Sobre o projeto

O **Lista de Tarefas** é uma aplicação mobile criada para transformar
organização em produtividade. Com uma experiência visual moderna e intuitiva,
o usuário pode criar sua conta, planejar tarefas por data e acompanhar seu
progresso em tempo real.

O projeto combina uma interface com tema escuro, gradientes neon e efeito
**glassmorphism** com serviços gerenciados do Firebase para autenticação e
persistência de dados.

> 🎯 **Objetivo:** construir uma solução funcional de produtividade aplicando
> boas práticas de organização de código, integração com serviços em nuvem e
> desenvolvimento multiplataforma.

## 🧭 Índice

- [✨ Funcionalidades](#-funcionalidades)
- [🛠️ Tecnologias](#️-tecnologias)
- [🏗️ Arquitetura](#️-arquitetura)
- [☁️ Persistência dos dados](#️-persistência-dos-dados)
- [💼 Conhecimentos do ecossistema .NET](#-conhecimentos-do-ecossistema-net)
- [⚙️ Pré-requisitos](#️-pré-requisitos)
- [🔥 Configuração do Firebase](#-configuração-do-firebase)
- [🚀 Instalação e execução](#-instalação-e-execução)
- [🔮 Próximas evoluções](#-próximas-evoluções)
- [👤 Autor](#-autor)

## ✨ Funcionalidades

### 🔐 Autenticação

- ✅ Cadastro com nome, e-mail, senha e confirmação de senha.
- ✅ Login com **Firebase Authentication**.
- ✅ Logout seguro e retorno à tela de autenticação.
- ✅ Exibição do nome do usuário autenticado.

### ✅ Gerenciamento de tarefas

- ➕ Criação de tarefas vinculadas a uma data.
- 🔄 Listagem em tempo real com streams do Firestore.
- 📋 Separação entre tarefas **pendentes** e **concluídas**.
- ☑️ Marcação e desmarcação de tarefas.
- 🗑️ Exclusão de tarefas.
- 👤 Dados isolados por usuário autenticado.

### 📅 Organização por calendário

- 🗓️ Calendário mensal interativo.
- ◀️▶️ Navegação entre meses.
- 📍 Seleção de uma data específica.
- 📆 Atalho para retornar ao dia atual.

### 🎨 Experiência visual

- 🌙 Tema escuro.
- 🌌 Fundo personalizado com imagem espacial.
- 💚 Gradientes neon em verde e ciano.
- 🪟 Cartões translúcidos com efeito glassmorphism.
- 📱 Layout adaptado para diferentes tamanhos de tela.

## 🛠️ Tecnologias

| Tecnologia | Uso no projeto |
| --- | --- |
| 🦋 [Flutter](https://flutter.dev/) | Framework multiplataforma |
| 🎯 [Dart](https://dart.dev/) | Linguagem de programação |
| 🔥 [Firebase Core](https://pub.dev/packages/firebase_core) | Inicialização do Firebase |
| 🔐 [Firebase Authentication](https://pub.dev/packages/firebase_auth) | Cadastro, login e logout |
| ☁️ [Cloud Firestore](https://pub.dev/packages/cloud_firestore) | Persistência e sincronização em tempo real |
| ✒️ [Google Fonts](https://pub.dev/packages/google_fonts) | Recursos tipográficos |
| 🍎 [Cupertino Icons](https://pub.dev/packages/cupertino_icons) | Ícones complementares |

## 🏗️ Arquitetura

O código está organizado por funcionalidades e serviços, mantendo a
responsabilidade de cada parte bem definida:

```text
📁 lib/
├── 📄 main.dart
├── 📁 features/
│   ├── 📁 Auth/
│   │   ├── 📄 cadastro_page.dart
│   │   └── 📄 login_page.dart
│   ├── 📄 calendar_page.dart
│   └── 📄 home_page.dart
└── 📁 service/
    ├── 📄 authservice.dart
    └── 📄 firestoreservice.dart

📁 assets/
└── 🖼️ espaco.jpg
```

### 🧩 Responsabilidades

- `main.dart`: inicializa o Flutter e o Firebase e configura a aplicação.
- `login_page.dart`: apresenta o login e direciona para o cadastro.
- `cadastro_page.dart`: cria usuários e valida a confirmação de senha.
- `home_page.dart`: gerencia tarefas, filtros, logout e navegação.
- `calendar_page.dart`: permite selecionar datas e navegar entre meses.
- `authservice.dart`: encapsula autenticação e atualização do perfil.
- `firestoreservice.dart`: centraliza criação, leitura, atualização e exclusão
  das tarefas.

## ☁️ Persistência dos dados

As tarefas são gravadas no Firestore em coleções separadas por usuário e por
data:

```text
usuarios/
└── {uid_do_usuario}/
    └── {dd-mm-aaaa}/
        └── {id_da_tarefa}
```

Cada tarefa possui uma estrutura semelhante a:

```json
{
  "titulo": "Estudar para a prova",
  "concluida": false,
  "criadoEm": "server timestamp"
}
```

> 🔒 **Privacidade:** a aplicação foi estruturada para consultar as tarefas
> dentro do contexto do usuário autenticado. Antes de usar em produção, revise
> e restrinja as regras de segurança do Firestore.

## 💼 Conhecimentos do ecossistema .NET

Embora a implementação desta aplicação utilize **Flutter** e **Dart**, o
desenvolvimento aproveitou conhecimentos previamente adquiridos no ecossistema
**.NET**.

### 🧠 Competências aplicadas

- 🧱 Separação de responsabilidades entre telas, funcionalidades e serviços.
- 🗂️ Organização do código por camadas e domínios da aplicação.
- ⚡ Uso de operações assíncronas com `async`/`await`.
- 🔌 Criação de serviços para encapsular autenticação e acesso a dados.
- 🧮 Modelagem de dados por usuário e por data.
- 🔁 Tratamento de estados de carregamento, sucesso e erro.
- ♻️ Reaproveitamento de componentes e foco em manutenção.
- ☁️ Integração com backend e serviços gerenciados em nuvem.

> 🚀 A experiência prévia com padrões, serviços, integração com backend e
> programação assíncrona facilitou a adaptação ao Dart, ao Flutter e às APIs
> do Firebase. Este projeto demonstra a capacidade de transferir fundamentos
> consolidados do desenvolvimento **.NET** para uma stack multiplataforma.

## ⚙️ Pré-requisitos

Antes de começar, instale:

- 🦋 Flutter SDK compatível com o SDK do Dart definido em `pubspec.yaml`;
- 🤖 Android Studio ou ambiente equivalente configurado para Android;
- 🍎 Xcode, caso o projeto seja executado no macOS/iOS;
- 🔥 uma conta e um projeto no [Firebase Console](https://console.firebase.google.com/).

Verifique o ambiente com:

```bash
flutter doctor
```

## 🔥 Configuração do Firebase

1. 🆕 Crie um projeto no Firebase Console.
2. 📱 Adicione os aplicativos Android e/ou iOS ao projeto.
3. 🔐 Ative **Authentication > Sign-in method > E-mail/Password**.
4. ☁️ Crie o banco **Cloud Firestore**.
5. 📥 Configure os arquivos nativos:
   - Android: `android/app/google-services.json`;
   - iOS: `ios/Runner/GoogleService-Info.plist`.
6. 🛡️ Revise as regras do Firestore e limite o acesso ao usuário autenticado.

> ⚠️ Nunca publique credenciais, chaves privadas ou arquivos de configuração
> sensíveis no repositório.

## 🚀 Instalação e execução

### 1️⃣ Clone o repositório

```bash
git clone https://github.com/Ca22io/lista_de_tarefas.git
cd lista_de_tarefas
```

### 2️⃣ Instale as dependências

```bash
flutter pub get
```

### 3️⃣ Execute a aplicação

```bash
flutter run
```

### 4️⃣ Analise o código

```bash
flutter analyze
```

### 5️⃣ Gere um APK de release

```bash
flutter build apk --release
```

## 👤 Autor

Desenvolvido por **Ca22io**, com aplicação de conhecimentos em desenvolvimento
de software, integração com serviços em nuvem e fundamentos consolidados no
ecossistema **.NET**.

<div align="center">

### 🌐 Conecte-se comigo

[![GitHub](https://img.shields.io/badge/GitHub-Ca22io-181717?logo=github&logoColor=white)](https://github.com/Ca22io)
[![Repositório](https://img.shields.io/badge/Repositório-Lista%20de%20Tarefas-86FA43?logo=github&logoColor=black)](https://github.com/Ca22io/lista_de_tarefas)

**[⭐ Visite meu GitHub](https://github.com/Ca22io)**

</div>

## 📄 Licença

Este projeto não possui uma licença open source definida no momento.
