# 🚀 Desafio Chat

Este projeto é uma aplicação de chat full-stack composta por uma API em Ruby on Rails e um Frontend em Vue.js.

## 📋 Pré-requisitos

*   **Docker** e **Docker Compose**

---

## 🛠️ Configuração e Execução (Via Docker - Recomendado)

A maneira mais fácil de rodar o projeto é usando Docker:

```bash
# 1. Clone o repositório
git clone https://github.com/matheusmoura/desafio-chat.git
cd desafio-chat

# 2. Inicie a aplicação
docker-compose up --build
```

- **Frontend**: [http://localhost:8080](http://localhost:8080)
- **Backend API**: [http://localhost:3000](http://localhost:3000)

> [!NOTE]
> O banco de dados é automaticamente configurado e populado com seeds no primeiro boot do container.

---

## 🛠️ Execução Manual (Alternativa)

Se preferir rodar localmente sem Docker, você precisará de **Ruby 3.3+**, **Node 20+** e **SQLite3**.

### 1. Backend (API Rails)
```bash
cd chat_api
bundle install
rails db:setup
rails server
```

### 2. Frontend (Vue.js)
```bash
cd chat_frontend
npm install
npm run dev
```
Acesse em: **http://localhost:5173**

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
 

## Diferenciais

*   **Mecanismo de autenticação**: JWT
*   **Paginação**: Carregamento de mensagens antigas com o Kaminari
*   **Upload de Arquivos**: Envio imagens.