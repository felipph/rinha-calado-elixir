import Config

config :rinha_calado, RinhaCalado, port: System.get_env("PORT", "80") |> String.to_integer()

config :libcluster,
  topologies: [
    cluster: [
      strategy: Cluster.Strategy.Gossip,
      config: [
        port: 45892,
        if_addr: "0.0.0.0",
        broadcast_only: true,
        secret: "somepassword"]
    ]
  ]
