defmodule ImageFinder.DownloaderDynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    IO.puts("init dynamic supervisor")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(state) do
    spec = ImageFinder.Downloader.child_spec({state})
    child = DynamicSupervisor.start_child(__MODULE__, spec)
    IO.inspect(child)
    child
  end
  
end
