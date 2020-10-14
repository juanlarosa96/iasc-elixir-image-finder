defmodule ImageFinder.Worker do
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

  def handle_cast({:fetch, source_file, target_directory}, _state) do
    content = File.read!(source_file)
    {:ok, pid} = ImageFinder.ParserDynamicSupervisor.start_child([])
    GenServer.cast(pid, {:parse, content, target_directory})
    {:stop, :normal, _state}
  end
end
