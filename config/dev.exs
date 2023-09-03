import Config

config :rinha_calado, RinhaCalado, port: System.get_env("PORT", "8080") |> String.to_integer()

config :libcluster,
  topologies: [
    cluster: [
      strategy: Cluster.Strategy.Gossip
    ]
  ]
