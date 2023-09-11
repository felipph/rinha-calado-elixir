FROM elixir:1.14.5-alpine

# instalando o gerenciar de pacotes do elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# também funciona essa sintaxe:
# RUN mix do local.hex --force, local.rebar --force

WORKDIR /app
ENV APP_NAME=api01
# copiar tudo da raiz do projeto para o contêiner docker
COPY ./config           /app/config
COPY ./lib              /app/lib
COPY ./mix.exs          /app/mix.exs
COPY ./mix.lock         /app/mix.lock
COPY ./.formatter.exs   /app/.formatter.exs



# instalar as dependencias
RUN cd /app && mix do deps.get, deps.compile

# executar o servidor
# CMD ["iex", "-S", "mix", "run"]

 CMD ["sh", "-c", "elixir --sname ${APP_NAME} -S mix run --no-halt"]