defmodule RinhaCalado.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    topologies = Application.get_env(:libcluster, :topologies, [])

    children = [
      {Cluster.Supervisor, [topologies, [name: RinhaCalado.ClusterSupervisor]]},
      {RinhaCalado.Cache, []},
      {Plug.Cowboy, scheme: :http, plug: RinhaCalado, options: [port: cowboy_port()]}

    ]

    opts = [strategy: :one_for_one, name: RinhaCalado.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:rinha_calado, :cowboy_port, 8080)
end
