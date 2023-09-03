import Config

config :rinha_calado, RinhaCalado, port: System.get_env("PORT", "8080") |> String.to_integer()

config :rinha_calado, RinhaCalado.Cache,
  stats: true,
  telemetry: true

import_config("#{config_env()}.exs")
