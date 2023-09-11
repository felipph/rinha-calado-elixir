defmodule RinhaCalado.PersistCache do
  use GenServer

  alias RinhaCalado.Cache

  require Logger


  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, opts, {:continue, :cache_to_insert}}
  end

  @impl true
  def handle_continue(:cache_to_insert, state) do

    schedule_work()
    {:noreply, state}

  end

  @impl true
  def handle_info(:update, state) do
    insert_all()

    schedule_work()

    {:noreply, state}
  end

  defp insert_all do
    cache_pessoas = Cache.all()
    case cache_pessoas do
      []            -> {:ok} #Logger.info("Aguardando")# {:ok}
      cache_pessoas -> cache_pessoas
      |> monta_values()
      |> salva_pessoas()
    end
    Enum.each(cache_pessoas, fn item -> Cache.delete(item) end)
  end

  def monta_values(cache_pessoas) do
    Enum.map(cache_pessoas, fn i ->
      "('" <> Enum.join(
        [
          i,
          RinhaCalado.Cache.get(i)["apelido"],
          RinhaCalado.Cache.get(i)["nome"],
          RinhaCalado.Cache.get(i)["nascimento"],
          Enum.join(RinhaCalado.Cache.get(i)["stack"],","),

        ], "','") <> "')"

    end )
    |> Enum.join(",")
  end

  defp salva_pessoas(pessoas) do
    base_sql = "INSERT INTO PESSOAS (ID, APELIDO, NOME, NASCIMENTO, STACK) VALUES " <> pessoas
    Postgrex.query(:postgresql, base_sql, [], [])
  end

  defp schedule_work do
    Process.send_after(self(), :update, 1000)
  end
end
