FROM elixir:1.16.2

RUN apt-get update && \
  apt-get install -y postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get --only prod

RUN mix phx.digest

CMD ["/app/entrypoint.sh"]
