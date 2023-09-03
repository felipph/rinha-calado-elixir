defmodule RinhaCalado.Cache do
  use Nebulex.Cache,
    otp_app: :rinha_calado,
    adapter: Nebulex.Adapters.Replicated

end
