# 📢 C2S Feedback - Sistema de Avaliação de Atendimento

## 📌 Visão Geral
O **C2S Feedback** é uma API desenvolvida em **Ruby on Rails** para gerenciar avaliações de atendimento, fornecendo feedback sobre a experiência dos clientes com atendentes. O sistema inclui autenticação de usuários, permissões, notificações por e-mail, web scraping e background jobs.

---

## 🚀 Funcionalidades Principais

✅ **Autenticação de Usuários:** Registro e login com Devise.  
✅ **Gestão de Avaliações:** CRUD para avaliações de atendimento.  
✅ **Controle de Permissões:** Definição de papéis para usuários (Cliente, Atendente, Gestor).  
✅ **Notificações:** Envio de alertas por e-mail via Sidekiq.  
✅ **Web Scraping:** Extração de dados do **ReclameAqui** com **Nokogiri**.  
✅ **Background Jobs:** Processamento assíncrono de notificações e resumos diários.  
✅ **Testes Automatizados:** Cobertura de testes unitários e de integração.  
✅ **Documentação da API:** Swagger/OpenAPI com **Rswag** e **Redoc**.  
✅ **Infraestrutura Dockerizada:** Configuração de ambiente com **Docker e Docker Compose**.  

---

## 📂 Estrutura do Projeto

📌 **Backend:** Ruby on Rails (API-only)  
📌 **Banco de Dados:** PostgreSQL  
📌 **Autenticação:** Devise  
📌 **Filtragem de Permissões:** Pundit  
📌 **Background Jobs:** Sidekiq + Redis  
📌 **Web Scraping:** Nokogiri  
📌 **Documentação da API:** Rswag e Redoc  
📌 **Containerização:** Docker e Docker Compose  

---

## 🔧 Configuração do Ambiente

### ✅ **Pré-requisitos**
Certifique-se de ter instalado:
- **Docker** e **Docker Compose**
- **Ruby 3.3.0**
- **Bundler**
- **PostgreSQL**

### 📌 **Passos para Rodar o Projeto**

1️⃣ **Clone o repositório:**
```bash
git clone https://github.com/seu-usuario/c2s_feedback.git
cd c2s_feedback
```

2️⃣ **Configure as variáveis de ambiente**
Crie um arquivo `.env` na raiz do projeto e preencha com as configurações do banco:
```ini
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=c2s_feedback_development

PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=admin
```

3️⃣ **Suba os containers com Docker Compose**
```bash
docker-compose up --build
```

4️⃣ **Crie o banco de dados**
```bash
docker exec -it c2s_feedback_web rails db:create db:migrate db:seed
```

5️⃣ **Acesse a aplicação**
A API estará disponível em `http://localhost:3000`

6️⃣ **Executando os testes**
```bash
docker exec -it c2s_feedback_web rspec
```

---

## 🔗 Rotas da API

### 📌 **Autenticação**
- `POST /clients/sign_in` → Login do Cliente  
- `POST /clients/sign_up` → Registro de Cliente  
- `DELETE /clients/sign_out` → Logout  

### 📌 **Avaliações**
- `POST /api/v1/evaluation_requests` → Criar solicitação de avaliação  
- `GET /api/v1/evaluation_requests/:token` → Acessar link de avaliação  
- `POST /api/v1/evaluations` → Criar avaliação  
- `GET /api/v1/evaluations` → Listar avaliações  

### 📌 **Notificações**
- Envio de e-mails com **ActionMailer + Sidekiq**  
- Resumo diário para atendentes  

### 📌 **Web Scraping**
- Coleta de dados do **ReclameAqui** para insights  

---

## 📜 Roadmap de Desenvolvimento

### 🔹 **Épicos Concluídos**
✅ Infraestrutura e Configuração Inicial  
✅ Documentação Inicial da API  
✅ Autenticação e Usuários  
✅ Gestão de Avaliações  
✅ Notificações e Background Jobs  
✅ Web Scraping e Integração Externa  
✅ Testes Automatizados  

### 🔹 **Próximos Passos**
📌 Melhorias na interface de administração  
📌 Implementação de relatórios gráficos  

---

## 🛠️ Tecnologias Utilizadas

- **Ruby on Rails 7.1**
- **PostgreSQL**
- **Redis + Sidekiq**
- **Devise + Pundit**
- **Nokogiri (Web Scraping)**
- **Swagger + Rswag + Redoc**
- **Docker + Docker Compose**

---

## 🎯 Contribuição

Contribuições são bem-vindas! Para contribuir:
1. **Fork** o repositório  
2. **Crie uma branch** (`git checkout -b feature/nova-funcionalidade`)  
3. **Commit suas alterações** (`git commit -m 'Adiciona nova funcionalidade'`)  
4. **Envie um Pull Request**  

---

## 📝 Licença

Este projeto é licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
