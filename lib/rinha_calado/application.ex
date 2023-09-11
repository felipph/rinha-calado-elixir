defmodule RinhaCalado.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    db_config = [
      name: :postgresql,
      hostname: "db",
      database: "postgres",
      username: "postgres",
      password: "postgres",
      pool_size: 10
    ]

    topologies = Application.get_env(:libcluster, :topologies, [])

    children = [
      {Cluster.Supervisor, [topologies, [name: RinhaCalado.ClusterSupervisor]]},
      {RinhaCalado.Cache, []},
      {RinhaCalado.PersistCache, []},
      {Plug.Cowboy, scheme: :http, plug: RinhaCalado, options: [port: cowboy_port()]},
      {Postgrex, db_config}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__ ]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:rinha_calado, :port, 80)
end
