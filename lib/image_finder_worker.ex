defmodule ImageFinder.Worker do
  use GenServer

  def start_link(__args) do
    GenServer.start_link(__MODULE__, :ok, name: Worker)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:fetch, source_file, target_directory}, _from, state) do
    content = File.read! source_file
    GenServer.cast(Parser, {:parse, content, target_directory})
    {:reply, :ok, state}
  end

end
