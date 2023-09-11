import Config

config :rinha_calado, RinhaCalado.Cache,
  stats: true,
  telemetry: true

import_config("#{config_env()}.exs")
