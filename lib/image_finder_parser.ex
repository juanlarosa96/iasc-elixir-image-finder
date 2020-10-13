defmodule ImageFinder.Parser do
  use GenServer

  def start_link(__args) do
    GenServer.start_link(__MODULE__, :ok, name: Parser)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:parse, content, target_directory}, state) do
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    Regex.scan(regexp, content)
      |> Enum.map(&List.first/1)
      |> Enum.map(&(download &1, target_directory))
    {:noreply, state}
  end

  def download(line, out) do
    {:ok, pid} = ImageFinder.DownloaderDynamicSupervisor.start_child([])
    GenServer.cast(pid, {:fetch, line, out})
  end

end
