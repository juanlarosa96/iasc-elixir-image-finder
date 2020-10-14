defmodule ImageFinder.Parser do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(:ok, args) do
    {:ok, args}
  end

  def child_spec(state) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end


  def handle_cast({:parse, content, target_directory}, _state) do
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    Regex.scan(regexp, content)
      |> Enum.map(&List.first/1)
      |> Enum.map(&(download &1, target_directory))
      {:stop, :normal, _state}
  end

  def download(line, out) do
    {:ok, pid} = ImageFinder.DownloaderDynamicSupervisor.start_child([])
    GenServer.cast(pid, {:fetch, line, out})
  end

end
