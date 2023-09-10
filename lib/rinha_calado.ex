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
    data = Cache.get(id)
    {status, data} = case data do

      %{} -> { 200, data}
      _   -> { 404, %{error: "Not found!"}}
    end

    send_resp(conn, status, Poison.encode!(data))
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

        %{
          "apelido"    => _, 	    # obrigatório, único, string de até 32 caracteres.
          "nome"       => _,      # obrigatório, string de até 100 caracteres.
          "nascimento" => _,	    # obrigatório, string para data no formato AAAA-MM-DD (ano, mês, dia).
          "stack"      => [_ | _] # opcional, vetor de string com cada elemento sendo obrigatório e de até 32 caracteres.}
        } -> {200, processar_registro(conn.body_params)}


        %{
          "apelido"    => _, 	 # obrigatório, único, string de até 32 caracteres.
          "nome"       => _,   # obrigatório, string de até 100 caracteres.
          "nascimento" => _,	 # obrigatório, string para data no formato AAAA-MM-DD (ano, mês, dia).
          "stack"      => []   # opcional, vetor de string com cada elemento sendo obrigatório e de até 32 caracteres.}
        } -> {200, processar_registro(conn.body_params)}

        _ -> {422, Poison.encode!(%{error: "Invalid request"})}

      end
      send_resp(conn, status, body)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  def processar_registro(body) do
    itemId = UUID.uuid4();
    body = %{body | "id" => itemId};
    Cache.put(itemId, body)
    Poison.encode!(%{response: "Salvo!", data: body})
  end
end
