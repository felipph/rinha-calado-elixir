FROM elixir:1.14.5-alpine

# instalando o gerenciar de pacotes do elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# também funciona essa sintaxe:
# RUN mix do local.hex --force, local.rebar --force

# copiar tudo da raiz do projeto para o contêiner docker
COPY ./config ./config
COPY ./lib ./lib
COPY ./mix.exs ./mix.exs
COPY ./mix.lock ./mix.lock
COPY ./.formatter.exs ./.formatter.exs

# instalar as dependencias
RUN mix do deps.get, deps.compile

# executar o servidor
CMD ["iex", "mix", "-S", "run"]