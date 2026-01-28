# 🚀 Desafio Chat

Este projeto é uma aplicação de chat full-stack composta por uma API em Ruby on Rails e um Frontend em Vue.js.

## 📋 Pré-requisitos

*   **Ruby**: 3.x+
*   **Node.js**: 18+
*   **SQLite3**

## 🛠️ Configuração e Execução

### 1. Backend (API Rails)

Em um terminal:

```bash
cd chat_api

# 1. Instale as dependências
bundle install

# 2. Prepare o banco de dados (Criação, Migração e Seeds)
rails db:setup  # Isso roda db:create, db:migrate e db:seed automaticamente

# 3. Inicie o servidor (Porta 3000)
rails server
```

### 2. Frontend (Vue.js)

Em OUTRO terminal:

```bash
cd chat_frontend

# 1. Instale as dependências
npm install

# 2. Inicie o servidor de desenvolvimento (Porta 5173 e 2424)
npm run dev
```

Acesse a aplicação em: **http://localhost:5173**

## 🔑 Usuários para Teste

Estes usuários já são criados automaticamente pelo comando `rails db:setup` (via `db/seeds.rb`).

| Usuário | Senha | Função |
| :--- | :--- | :--- |
| **Matheus_Dev** | `123456` | Desenvolvedor (Você) |
| **Alice_ProductManager** | `123456` | Gerente de Produto |
| **Bruno_Designer** | `123456` | Designer |

## 🧪 Funcionalidades

*   **Login JWT**: Autenticação segura.
*   **Chat em Tempo Real (Simulado)**: Envio e recebimento imediato de mensagens.
*   **Upload de Arquivos**: Envio imagens.
*   **Histórico**: Persistência de mensagens no banco de dados.
*   **Layout Minimalista**: Interface limpa e funcional.
