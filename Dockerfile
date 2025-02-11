# Usando a versão do Ruby compatível com seu projeto
FROM ruby:3.3.0

# Definindo diretório de trabalho dentro do container
WORKDIR /app

# Instalando dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

# Copiando arquivos necessários para instalação de dependências
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 3

# Copiando o restante da aplicação
COPY . .

# Expondo a porta padrão do Rails
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
