defmodule RinhaCalado do

  require Logger
  alias RinhaCalado.Cache
  alias UUID
  use Plug.Router
  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)




  get "/pessoas/:id" do
    data = Cache.get(:id);
    Logger.info  data
    # data = %{status: "OK"}
    send_resp(conn, 200, "ok")
  end

  get "/pessoas/?t=:search" do
    send_resp(conn, 200, "OK")
  end

  get "/contagem-pessoas" do
    send_resp(conn, 200, "OK")
  end

  post "/pessoas" do

    {status, body} =
      case conn.body_params do
        %{"nome" => _, "idade" => _} -> {200, processar_registro(conn.body_params)}
        _ -> {422, Poison.encode!(%{error: "Invalid request"})}

      end
      send_resp(conn, status, body)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  def processar_registro(body) do
    itemId = UUID.uuid4();
    body = Map.put(body, :id, itemId);
    Cache.put(:itemId, body)
    Poison.encode!(%{response: "Salvo!", data: body})
  end
end
